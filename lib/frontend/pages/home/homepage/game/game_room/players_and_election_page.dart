// author: Lukas Horst

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/convertAppwriteData.dart';
import 'package:secret_hitler/backend/helper/datastructure_functions.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/toggle_gesture_detector.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget_stack.dart';
import 'package:secret_hitler/frontend/widgets/components/text/game_room_text.dart';
import 'package:secret_hitler/frontend/widgets/components/transformed_widgets/angle_widget.dart';

class PlayersAndElection extends ConsumerStatefulWidget {

  final PlayersAndElectionBackend backend;

  const PlayersAndElection({super.key, required this.backend});

  @override
  ConsumerState<PlayersAndElection> createState() => PlayersAndElectionState();
}

class PlayersAndElectionState extends ConsumerState<PlayersAndElection> with AutomaticKeepAliveClientMixin {

  final List<GlobalKey<OpacityAnimationState>> _opacityKeys = [
    GlobalKey<OpacityAnimationState>(), // Visibility of the yes card
    GlobalKey<OpacityAnimationState>(), // Visibility of the no card
    GlobalKey<OpacityAnimationState>(), // Visibility of the liberal party membership card
    GlobalKey<OpacityAnimationState>(), // Visibility of the fascist party membership card
  ];
  final List<List<double>> _initialOpacityValues = [];
  final List<Widget> _initialBallotImage = [];
  final List<GlobalKey<FlipAnimationState>> _membershipFlipKey = [
    GlobalKey<FlipAnimationState>(),  // Liberal card
    GlobalKey<FlipAnimationState>(),  // Fascist card
  ];
  late List<int> investigatedPlayers;
  late PlayersAndElectionBackend backend;
  int _voting = 0;
  bool _init = true;
  bool _ballotCardsVisibility = true;
  late int _hitler;
  bool _progressBlocked = false;
  late final String _initialExplainingText;
  late String _currentExplainingText;
  late List<int> _killedPlayers;
  late List<int> _investigatedPlayers;

  // Method to check if the ballot cards should be flipped or not
  void _checkBallotCards(GameState gameState) async {
    int playState = gameState.playState;
    List<int> chancellorVoting = gameState.chancellorVoting;
    if (_init) {
      // Not yet voted
      if (playState == 1 && chancellorVoting[backend.ownPlayerIndex] == 0) {
        backend.cardsFlipped = true;
        switchListElements(_initialBallotImage, 0, 2);
        switchListElements(_initialBallotImage, 1, 3);
      }
    } else {
      await backend.flipBallotCards(playState, chancellorVoting);
    }
  }

  // Method to check if the president must investigate one player
  Future<void> _checkPresidentialInvestigation() async {
    final gameState = ref.read(gameStateProvider);
    if (backend.boardOverviewBackend.isOnTheMove(
        ref, rightGameState: gameState.playState) && gameState.playState == 6) {
      if (_init) {
        for (int i=0; i < 4; i++) {
          switchListElements(_initialOpacityValues[i], 0, 1);
        }
        _ballotCardsVisibility = false;
      } else {
        if (_ballotCardsVisibility) {
          _ballotCardsVisibility = false;
          _opacityKeys[0].currentState?.animate();
          _opacityKeys[1].currentState?.animate();
          await Future.delayed(const Duration(milliseconds: 500));
          _opacityKeys[2].currentState?.animate();
          _opacityKeys[3].currentState?.animate();
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } else if (!_ballotCardsVisibility) {
      _ballotCardsVisibility = true;
      int role = backend.playerRoles[investigatedPlayers[
        investigatedPlayers.length - 1]] == 'Liberal'
          ? 0
          : 1;
      if (role == 0) {
        _opacityKeys[3].currentState?.animate();
      } else {
        _opacityKeys[2].currentState?.animate();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      _membershipFlipKey[role].currentState?.animate();
      await Future.delayed(const Duration(seconds: 6));
      _membershipFlipKey[role].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 600));
      _opacityKeys[role + 2].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 700));
      _opacityKeys[0].currentState?.animate();
      _opacityKeys[1].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Method to check if the explaining text must be changed
  Future<void> _checkExplainingText() async {
    BoardOverviewBackend boardOverviewBackend = backend.boardOverviewBackend;
    final gameState = ref.read(gameStateProvider);
    int playState = gameState.playState;
    // Checking if a player was killed
    if (!listEquals(_killedPlayers, gameState.killedPlayers)) {
      _killedPlayers = convertDynamicToIntList(copyList(gameState.killedPlayers));
      String shotPlayer = backend.playerNames[_killedPlayers[_killedPlayers.length-1]];
      _changeExplainingText('$shotPlayer ${AppLanguage.getLanguageData()['was shot']}!');
      await Future.delayed(const Duration(seconds: 4));
    }
    // Checking if a player was investigated
    if (!listEquals(_investigatedPlayers, gameState.investigatedPlayers)) {
      _investigatedPlayers = convertDynamicToIntList(copyList(gameState.investigatedPlayers));
      String investigatedPlayer = backend.playerNames[_investigatedPlayers[investigatedPlayers.length-1]];
      _changeExplainingText('$investigatedPlayer ${AppLanguage.getLanguageData()['was investigated']}');
      await Future.delayed(const Duration(seconds: 4));
    }
    if (isVotingFinished(gameState.chancellorVoting, gameState.killedPlayers)) {
      if (gameState.playState > 2) {
        _changeExplainingText(AppLanguage.getLanguageData()['The voting was successful']);
      } else {
        _changeExplainingText(AppLanguage.getLanguageData()['The voting was not successful']);
      }
    } else if (playState == 0) {
      if (boardOverviewBackend.isOnTheMove(ref)) {
        _changeExplainingText(AppLanguage.getLanguageData()['Pick a chancellor candidate']);
      } else {
        _changeExplainingText(AppLanguage.getLanguageData()['The president picks a chancellor candidate']);
      }
    } else if (playState == 1) {
      bool hasVoted = gameState.chancellorVoting[backend.ownPlayerIndex] != 0;
      if (hasVoted) {
        _changeExplainingText(AppLanguage.getLanguageData()['Wait for the other player\'s votes']);
      } else {
        int chancellor = gameState.currentChancellor!;
        String chancellorName = backend.playerNames[chancellor];
        _changeExplainingText('${AppLanguage.getLanguageData()['Vote for or against']}:\n$chancellorName');
      }
    } else if (playState == 6) {
      if (boardOverviewBackend.isOnTheMove(ref)) {
        _changeExplainingText(AppLanguage.getLanguageData()['Investigate a player\'s indentity card']);
      } else {
        _changeExplainingText(AppLanguage.getLanguageData()['The president investigates a player\'s indentity card']);
      }
    } else if (playState == 7) {
      if (boardOverviewBackend.isOnTheMove(ref)) {
        _changeExplainingText(AppLanguage.getLanguageData()['Pick the next president']);
      } else {
        _changeExplainingText(AppLanguage.getLanguageData()['The president picks the next president']);
      }
    } else if (playState == 8) {
      if (boardOverviewBackend.isOnTheMove(ref)) {
        _changeExplainingText(AppLanguage.getLanguageData()['Shoot a player']);
      } else {
        _changeExplainingText(AppLanguage.getLanguageData()['The president shoots a player']);
      }
    } else if (playState == 9) {
      _changeExplainingText(AppLanguage.getLanguageData()['The liberals won']);
    } else if (playState == 10) {
      _changeExplainingText(AppLanguage.getLanguageData()['The fascists won']);
    }
    if (_currentExplainingText.isEmpty) {
      _changeExplainingText('');
    }
  }

  // Method to set the initial text or update the text via animation
  Future<void> _changeExplainingText(String text) async {
    if (!_init) {
      if (text != _currentExplainingText) {
        final gameRoomTextKey = ref.read(playerAndElectionGameRoomTextProvider);
        await gameRoomTextKey.currentState?.updateText(text);
      }
    }
    _currentExplainingText = text;
    if (_init) {
      _initialExplainingText = _currentExplainingText;
    }
  }

  @override
  void initState() {
    backend = widget.backend;
    _hitler = backend.playerOrder.indexOf(backend.hitler[1]);
    final gameState = ref.read(gameStateProvider);
    _killedPlayers = convertDynamicToIntList(copyList(gameState.killedPlayers));
    _investigatedPlayers = convertDynamicToIntList(copyList(gameState.investigatedPlayers));
    _checkExplainingText();
    investigatedPlayers = gameState.investigatedPlayers;
    for (int i=0; i < 2; i++) {
      _initialOpacityValues.add([1.0, 0.0]);
    }
    for (int i=0; i < 2; i++) {
      _initialOpacityValues.add([0.0, 1.0]);
    }
    for (int i=0; i < 2; i++) {
      _initialBallotImage.add(Image.asset(
        'assets/images/ballot_card_back.png',
        height: ScreenSize.screenHeight * 0.1,
        width: ScreenSize.screenWidth * 0.3,
      ));
    }
    for (int i=0; i < 2; i++) {
      _initialBallotImage.add(ToggleGestureDetector(
        onTap: () {
          if (_voting == 0) {
            _voting = i == 0
                ? 1
                : 2;
            voteForChancellor(ref, _voting, backend.ownPlayerIndex, _hitler);
          }
        },
        child: Image.asset(
          'assets/images/ballot_${i == 0 ? 'no' : 'yes'}_card_without_background.png',
          height: ScreenSize.screenHeight * 0.1,
          width: ScreenSize.screenWidth * 0.3,
        ),
      ));
    }
    _checkBallotCards(gameState);
    _checkPresidentialInvestigation();
    _init = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final gameRoomTextKey = ref.read(playerAndElectionGameRoomTextProvider);
    ref.listen(gameStateProvider, (previous, next) async {
      int playState = next.playState;
      List<int> chancellorVoting = next.chancellorVoting;
      // Reset the voting variable if the playState != 1
      if (playState != 1 && _voting != 0) {
        _voting = 0;
      }
      backend.flipBallotCards(playState, chancellorVoting);
      // If the voting didn't worked successfully cause two players voted at the
      // same time we repeat the voting
      if (_voting != 0 && chancellorVoting[backend.ownPlayerIndex] == 0
          && next.playState == 1) {
        voteForChancellor(ref, _voting, backend.ownPlayerIndex, _hitler);
      }
      investigatedPlayers = next.investigatedPlayers;
      _checkExplainingText();
      ProgressBlocker progressBlocker = ref.read(playersAndElectionProgressBlockerProvider.notifier);
      await progressBlocker.waitForUpdate();
      if (!_progressBlocked) {
        _progressBlocked = true;
        _checkPresidentialInvestigation();
        await Future.delayed(const Duration(seconds: 4));
        _progressBlocked = false;
      }
    });
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02,),
        SizedBox(
          height: ScreenSize.screenHeight * 0.86,
          width: ScreenSize.screenWidth * 0.96,
          child: Stack(
            children: [
              PlayerWidgetStack(backend: backend),
              Positioned(
                top: ScreenSize.screenHeight * 0.615,
                child: GameRoomText(
                  key: gameRoomTextKey,
                  duration: const Duration(milliseconds: 600),
                  initialText: _initialExplainingText,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.1,
                child: OpacityAnimation(
                  key: _opacityKeys[0],
                  duration: const Duration(milliseconds: 500),
                  begin: _initialOpacityValues[0][0],
                  end: _initialOpacityValues[0][1],
                  child: AngleWidget(
                    angleDegree: -15,
                    child: FlipAnimation(
                      key: backend.ballotCardFlipKeys[0],
                      duration: const Duration(milliseconds: 500),
                      firstWidget: _initialBallotImage[0],
                      secondWidget: _initialBallotImage[2],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.58,
                child: OpacityAnimation(
                  key: _opacityKeys[1],
                  duration: const Duration(milliseconds: 500),
                  begin: _initialOpacityValues[1][0],
                  end: _initialOpacityValues[1][1],
                  child: AngleWidget(
                    angleDegree: 15,
                    child: FlipAnimation(
                      key: backend.ballotCardFlipKeys[1],
                      duration: const Duration(milliseconds: 500),
                      firstWidget: _initialBallotImage[1],
                      secondWidget: _initialBallotImage[3],
                    ),
                  ),
                ),
              ),
              // Liberal membership
              Positioned(
                top: ScreenSize.screenHeight * 0.71,
                left: ScreenSize.screenWidth * 0.385,
                child: OpacityAnimation(
                  key: _opacityKeys[2],
                  duration: const Duration(milliseconds: 500),
                  begin: _initialOpacityValues[2][0],
                  end: _initialOpacityValues[2][1],
                  child: FlipAnimation(
                    key: _membershipFlipKey[0],
                    duration: const Duration(milliseconds: 600),
                    firstWidget: Image.asset(
                      'assets/images/membership_back.png',
                      height: ScreenSize.screenHeight * 0.17,
                      width: ScreenSize.screenWidth * 0.19,
                    ),
                    secondWidget: Image.asset(
                      'assets/images/membership_Liberal.png',
                      height: ScreenSize.screenHeight * 0.17,
                      width: ScreenSize.screenWidth * 0.19,
                    ),
                  ),
                ),
              ),
              // Fascist membership
              Positioned(
                top: ScreenSize.screenHeight * 0.71,
                left: ScreenSize.screenWidth * 0.385,
                child: OpacityAnimation(
                  key: _opacityKeys[3],
                  duration: const Duration(milliseconds: 500),
                  begin: _initialOpacityValues[3][0],
                  end: _initialOpacityValues[3][1],
                  child: FlipAnimation(
                    key: _membershipFlipKey[1],
                    duration: const Duration(milliseconds: 600),
                    firstWidget: Image.asset(
                      'assets/images/membership_back.png',
                      height: ScreenSize.screenHeight * 0.17,
                      width: ScreenSize.screenWidth * 0.19,
                    ),
                    secondWidget: Image.asset(
                      'assets/images/membership_Fascist.png',
                      height: ScreenSize.screenHeight * 0.17,
                      width: ScreenSize.screenWidth * 0.19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
