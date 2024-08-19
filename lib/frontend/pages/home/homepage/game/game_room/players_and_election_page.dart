// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/datastructure_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/toggle_gesture_detector.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget_stack.dart';
import 'package:secret_hitler/frontend/widgets/components/transformed_widgets/angle_widget.dart';

class PlayersAndElection extends ConsumerStatefulWidget {

  final PlayersAndElectionBackend backend;

  const PlayersAndElection({super.key, required this.backend});

  @override
  ConsumerState<PlayersAndElection> createState() => PlayersAndElectionState();
}

class PlayersAndElectionState extends ConsumerState<PlayersAndElection> with AutomaticKeepAliveClientMixin {

  late PlayersAndElectionBackend backend;
  int _voting = 0;
  bool _init = true;
  final List<Widget> _ballotImage = [];

  // Method to check if the ballot cards should be flipped or not
  void _checkBallotCards(GameState gameState) async {
    int playState = gameState.playState;
    List<int> chancellorVoting = gameState.chancellorVoting;
    if (_init) {
      // Not yet voted
      if (playState == 1 && chancellorVoting[backend.ownPlayerIndex] == 0) {
        backend.cardsFlipped = true;
        switchListElements(_ballotImage, 0, 2);
        switchListElements(_ballotImage, 1, 3);
      }
    } else {
      await backend.flipBallotCards(playState, chancellorVoting);
    }
  }

  @override
  void initState() {
    backend = widget.backend;
    final gameState = ref.read(gameStateProvider);
    for (int i=0; i < 2; i++) {
      _ballotImage.add(Image.asset(
        'assets/images/ballot_card_back.png',
        height: ScreenSize.screenHeight * 0.1,
        width: ScreenSize.screenWidth * 0.3,
      ));
    }
    for (int i=0; i < 2; i++) {
      _ballotImage.add(ToggleGestureDetector(
        onTap: () {
          if (_voting == 0) {
            _voting = i == 0
                ? 1
                : 2;
            voteForChancellor(ref, _voting, backend.ownPlayerIndex);
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
    _init = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen(gameStateProvider, (previous, next) async {
      int playState = next.playState;
      List<int> chancellorVoting = next.chancellorVoting;
      // Reset the voting variable if the playState != 1
      if (playState != 1 && _voting != 0) {
        _voting = 0;
      }
      if (playState < 4) {
        backend.flipBallotCards(playState, chancellorVoting);
      }
      // If the voting didn't worked successfully cause two players voted at the
      // same time we repeat the voting
      if (_voting != 0 && chancellorVoting[backend.ownPlayerIndex] == 0
          && next.playState == 1) {
        voteForChancellor(ref, _voting, backend.ownPlayerIndex);
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
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.1,
                child: AngleWidget(
                  angleDegree: -15,
                  child: FlipAnimation(
                    key: backend.ballotCardFlipKeys[0],
                    duration: const Duration(milliseconds: 500),
                    firstWidget: _ballotImage[0],
                    secondWidget: _ballotImage[2],
                  ),
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.58,
                child: AngleWidget(
                  angleDegree: 15,
                  child: FlipAnimation(
                    key: backend.ballotCardFlipKeys[1],
                    duration: const Duration(milliseconds: 500),
                    firstWidget: _ballotImage[1],
                    secondWidget: _ballotImage[3],
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
