// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/datastructure_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/size_animation.dart';

// A widget to display each player name and their actions
class PlayerWidget extends ConsumerStatefulWidget {

  final String playerName;
  final double height;
  final double width;
  final int index;
  final int ownPlayerIndex;
  final PlayersAndElectionBackend backend;

  const PlayerWidget({super.key, required this.playerName, required this.height,
    required this.width, required this.index, required this.ownPlayerIndex,
    required this.backend});

  @override
  ConsumerState<PlayerWidget> createState() => PlayerWidgetState();
}

class PlayerWidgetState extends ConsumerState<PlayerWidget> {

  final List<GlobalKey<OpacityAnimationState>> _opacityKeys = [
    GlobalKey<OpacityAnimationState>(), // Visibility of the divider and the presidential action
    GlobalKey<OpacityAnimationState>(), // Visibility of the execution image
    GlobalKey<OpacityAnimationState>(), // Visibility of the special election image
    GlobalKey<OpacityAnimationState>(), // Visibility of the investigate loyalty image
    GlobalKey<OpacityAnimationState>(), // Visibility of the voting icon
    GlobalKey<OpacityAnimationState>(), // Visibility of the former chancellor card
    GlobalKey<OpacityAnimationState>(), // Visibility of the former president card
    GlobalKey<OpacityAnimationState>(), // Visibility of the chancellor card
    GlobalKey<OpacityAnimationState>(), // Visibility of the president card
    GlobalKey<OpacityAnimationState>(), // Visibility of the yes card
    GlobalKey<OpacityAnimationState>(), // Visibility of the no card
    GlobalKey<OpacityAnimationState>(), // Visibility of the whole widget excepts the cards
    GlobalKey<OpacityAnimationState>(), // Visibility of the not hitler sign
  ];

  final List<List<double>> _initialOpacityValues = [];
  final List<double> _initialWidthValues = [];

  final List<GlobalKey<SizeAnimationState>> _sizeAnimationKeys = [
    GlobalKey<SizeAnimationState>(),
  ];

  final List<GlobalKey<FlipAnimationState>> _flipAnimationKeys = [
    GlobalKey<FlipAnimationState>(),  // Yes card
    GlobalKey<FlipAnimationState>(),  // No card
  ];

  bool _dividerVisible = false;
  late int _activeExecutivePower;
  late bool _chancellorVoting;
  bool _isFormerChancellor = false;
  bool _isFormerPresident = false;
  bool _isChancellor = false;
  bool _isPresident = false;
  final List<bool> _presidentialActions = [false, false, false, false];
  bool _isDead = false;
  bool _isInvestigated = false;
  bool _voted = false;
  bool _votingCardFlipped = false;
  bool _isNotHitler = false;
  bool _init = true;
  late PlayersAndElectionBackend _backend;

  List<OpacityAnimation> _getImages() {
    List<OpacityAnimation> imagesList = [];
    List<String> imagesNames = [
      'Execution_White',
      'Call_Special_Election_White',
      'Investigate_Loyalty_White',
    ];
    for (int i=0; i < 4; i++) {
      OpacityAnimation image = OpacityAnimation(
        key: _opacityKeys[i + 1],
        duration: const Duration(milliseconds: 0),
        begin: _initialOpacityValues[i + 1][0],
        end: _initialOpacityValues[i + 1][1],
        child: Center(
          child: Padding(
            padding: i != 1
                ? EdgeInsets.only(right: widget.width * 0.03)
                : const EdgeInsets.all(0),
            child: IconButton(
              onPressed: () {
                final gameState = ref.read(gameStateProvider);
                int playState = gameState.playState;
                // Changing from playState=0 to playState=1
                if (playState == 0) {
                  chancellorVotingState(ref, widget.index);
                // Picking the next president
                } else if (playState == 7) {
                  presidentialActionFinished(ref, widget.index, null, null);
                // Killing a player
                } else if (playState == 8) {
                  int hitler = _backend.playerOrder.indexOf(_backend.hitler[1]);
                  presidentialActionFinished(ref, null, hitler, widget.index);
                }
              },
              icon: i == 3
                  ? Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: ScreenSize.screenHeight * 0.028 +
                    ScreenSize.screenWidth * 0.028,)
                  : Image.asset(
                'assets/images/${imagesNames[i]}.png',
                height: i != 1
                    ? ScreenSize.screenHeight * 0.045
                    : ScreenSize.screenHeight * 0.05,
                width: i != 1
                    ? ScreenSize.screenHeight * 0.045
                    : ScreenSize.screenHeight * 0.05,
              ),
            ),
          ),
        ),
      );
      imagesList.add(image);
    }
    return imagesList;
  }

  // Method to make the divider visible or invisible
  Future<void> _dividerVisibility() async {
    if (_dividerVisible) {
      _dividerVisible = false;
      _opacityKeys[_activeExecutivePower].currentState?.animate();
      _sizeAnimationKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 250));
      _opacityKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1250));
    } else {
      _dividerVisible = true;
      _sizeAnimationKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 250));
      _opacityKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1250));
      _opacityKeys[_activeExecutivePower].currentState?.animate();
    }
  }

  // Method to make the yes or no card visible
  void _setVotingCard(bool voting) {
    if (!_voted) {
      _voted = true;
      // Yes card
      if (voting) {
        if (_init) {
          _initialOpacityValues[9] = [1.0, 0.0];
        } else {
          _opacityKeys[9].currentState?.animate();
        }
        // No card
      } else {
        if (_init) {
          _initialOpacityValues[10] = [1.0, 0.0];
        } else {
          _opacityKeys[10].currentState?.animate();
        }
      }
      _chancellorVoting = voting;
    }
  }

  // Method to flip the voting card for 20 seconds and then hide it
  Future<void> _flipVotingCard() async {
    if (!_votingCardFlipped) {
      _votingCardFlipped = true;
      // Yes card
      if (_chancellorVoting) {
        _flipAnimationKeys[0].currentState?.animate();
        // No card
      } else {
        _flipAnimationKeys[1].currentState?.animate();
      }
      await Future.delayed(const Duration(seconds: 10));
      await resetChancellorVoting(ref);
      await _hideVotingCard();
    }
  }

  // Method to hide the current voting card
  Future<void> _hideVotingCard() async {
    if (_voted) {
      _voted = false;
      if (_chancellorVoting) {
        _flipAnimationKeys[0].currentState?.animate();
        await Future.delayed(const Duration(milliseconds: 500));
        _opacityKeys[9].currentState?.animate();
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        _flipAnimationKeys[1].currentState?.animate();
        await Future.delayed(const Duration(milliseconds: 500));
        _opacityKeys[10].currentState?.animate();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      _votingCardFlipped = false;
    }
  }

  // Method to check the chancellor voting of all players
  Future<void> _checkChancellorVoting(List<int> chancellorVoting,
      int playState) async {
    if (chancellorVoting[widget.index] != 0) {
      _setVotingCard(chancellorVoting[widget.index] == 2);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (isVotingFinished(chancellorVoting) && !_votingCardFlipped && _voted) {
      await _flipVotingCard();
    }
  }

  // Method to check if we have any changes of the government and update if
  // it is so
  Future<void> _checkForGovernmentChanges(GameState gameState) async {
    bool change = false;
    if (_isFormerChancellor != (gameState.formerChancellor == widget.index)) {
      _isFormerChancellor = gameState.formerChancellor == widget.index;
      if (_init) {
        _initialOpacityValues[5] = [1.0, 0.0];
      } else {
        _opacityKeys[5].currentState?.animate();
        change = true;
      }
    }
    if (_isFormerPresident != (gameState.formerPresident == widget.index)) {
      _isFormerPresident = gameState.formerPresident == widget.index;
      if (_init) {
        _initialOpacityValues[6] = [1.0, 0.0];
      } else {
        _opacityKeys[6].currentState?.animate();
        change = true;
      }
    }
    if (_isChancellor != (gameState.currentChancellor == widget.index)) {
      _isChancellor = gameState.currentChancellor == widget.index;
      if (_init) {
        _initialOpacityValues[7] = [1.0, 0.0];
      } else {
        _opacityKeys[7].currentState?.animate();
        change = true;
      }
    }
    if (_isPresident != (gameState.currentPresident == widget.index)) {
      _isPresident = gameState.currentPresident == widget.index;
      if (_init) {
        _initialOpacityValues[8] = [1.0, 0.0];
      } else {
        _opacityKeys[8].currentState?.animate();
        change = true;
      }
    }
    if (change) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Method to check if the president has any action to take
  Future<void> _checkForPresidentActions(GameState gameState) async {
    int currentPresident = gameState.currentPresident;
    int playState = gameState.playState;

    if (!_init) {
      await _hidePresidentialActions(playState);
    }

    // Checking if the player is the current president because only the
    // president can see the actions
    if (currentPresident == widget.ownPlayerIndex && !_isPresident && !_isDead) {
      // Deciding a chancellor
      if (playState == 0  && !_presidentialActions[0] && !_isFormerPresident
          && !_isFormerChancellor) {
        _presidentialActions[0] = true;
        _activeExecutivePower = 4;
        if (_init) {
          switchListElements(_initialWidthValues, 0, 1);
          _initialOpacityValues[4] = [1.0, 0.0];
          _initialOpacityValues[0] = [1.0, 0.0];
        } else {
          await _dividerVisibility();
        }
      }
      // Investigate an identity
      if (playState == 6 && !_presidentialActions[1] && !_isInvestigated) {
        _presidentialActions[1] = true;
        _activeExecutivePower = 3;
        if (_init) {
          switchListElements(_initialWidthValues, 0, 1);
          _initialOpacityValues[3] = [1.0, 0.0];
          _initialOpacityValues[0] = [1.0, 0.0];
        } else {
          await _dividerVisibility();
        }
      }
      // Picking the next president
      if (playState == 7 && !_presidentialActions[2]) {
        _presidentialActions[2] = true;
        _activeExecutivePower = 2;
        if (_init) {
          switchListElements(_initialWidthValues, 0, 1);
          _initialOpacityValues[2] = [1.0, 0.0];
          _initialOpacityValues[0] = [1.0, 0.0];
        } else {
          await _dividerVisibility();
        }
      }
      // Killing a player
      if (playState == 8 && !_presidentialActions[3]) {
        _presidentialActions[3] = true;
        _activeExecutivePower = 1;
        if (_init) {
          switchListElements(_initialWidthValues, 0, 1);
          _initialOpacityValues[1] = [1.0, 0.0];
          _initialOpacityValues[0] = [1.0, 0.0];
        } else {
          await _dividerVisibility();
        }
      }
    }
  }

  // Method to check if a presidential action is finished to hide it
  Future<void> _hidePresidentialActions(int playState) async {
    bool change = false;
    // Deciding a chancellor
    if (_presidentialActions[0] && playState != 0) {
      change = true;
      _presidentialActions[0] = false;
      await _dividerVisibility();
    }
    // Investigate an identity
    if (_presidentialActions[1] && playState != 6) {
      change = true;
      _presidentialActions[1] = false;
      await _dividerVisibility();
    }
    // Picking the next president
    if (_presidentialActions[2] && playState != 7) {
      change = true;
      _presidentialActions[2] = false;
      await _dividerVisibility();
    }
    // Killing a player
    if (_presidentialActions[3] && playState != 8) {
      change = true;
      _presidentialActions[3] = false;
      await _dividerVisibility();
    }
    if (change) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Method to check if the player is dead
  Future<void> _checkForDeath(GameState gameState) async {
    if (_isDead != gameState.killedPlayers.contains(widget.index)) {
      _isDead = gameState.killedPlayers.contains(widget.index);
      if (_init) {
        _initialOpacityValues[11] = [0.3, 1.0];
      } else {
        _opacityKeys[11].currentState?.animate();
      }
    }
  }

  // Method to check if the player is confirmed not hitler
  Future<void> _checkForNotHitler(GameState gameState) async {
    if (_isNotHitler != gameState.notHitlerConfirmed.contains(widget.index)) {
      _isNotHitler = gameState.notHitlerConfirmed.contains(widget.index);
      if (_init) {
        _initialOpacityValues[12] = [1.0, 0.0];
      } else {
        _opacityKeys[12].currentState?.animate();
      }
    }
  }

  @override
  void initState() {
    _backend = widget.backend;
    for (int i=0; i < 11; i++) {
      _initialOpacityValues.add([0.0, 1.0]);
    }
    _initialOpacityValues.add([1.0, 0.3]);
    _initialOpacityValues.add([0.0, 1.0]);
    _initialWidthValues.add(widget.width);
    _initialWidthValues.add(widget.width/1.4 - 1.5);
    final gameState = ref.read(gameStateProvider);
    _checkForDeath(gameState);
    _isInvestigated = gameState.investigatedPlayers.contains(widget.index);
    _checkForGovernmentChanges(gameState);
    _checkForPresidentActions(gameState);
    _checkForNotHitler(gameState);
    _checkChancellorVoting(gameState.chancellorVoting, gameState.playState);
    _init = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gameStateProvider, (previous, next) async {
      _checkForDeath(next);
      _checkForNotHitler(next);
      await _checkForGovernmentChanges(next);
      _checkForPresidentActions(next);
      _checkChancellorVoting(next.chancellorVoting, next.playState);
    });
    return SizedBox(
      height: widget.height + ScreenSize.screenHeight * 0.0225,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          OpacityAnimation(
            key: _opacityKeys[11],
            duration: const Duration(milliseconds: 500),
            begin: _initialOpacityValues[11][0],
            end: _initialOpacityValues[11][1],
            child: SizedBox(
              height: widget.height,
              width: widget.width,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppDesign.getPrimaryColor(),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                  ),
                  OpacityAnimation(
                    key: _opacityKeys[0],
                    duration: const Duration(milliseconds: 1000),
                    begin: _initialOpacityValues[0][0],
                    end: _initialOpacityValues[0][1],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side
                        Container(
                          height: widget.height,
                          width: widget.width - widget.width/3 - 1.5,
                          decoration: BoxDecoration(
                            color: AppDesign.getPrimaryColor(),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            border: const Border(
                              left: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: VerticalDivider(
                            thickness: 3,
                            color: Colors.black,
                          ),
                        ),
                        // Right size
                        Container(
                          height: widget.height,
                          width: widget.width/3 - 1.5,
                          decoration: BoxDecoration(
                            color: AppDesign.getPrimaryColor(),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            border: const Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: _getImages(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizeAnimation(
                    key: _sizeAnimationKeys[0],
                    duration: const Duration(milliseconds: 1500),
                    firstHeight: widget.height,
                    firstWidth: _initialWidthValues[0],
                    secondHeight: widget.height,
                    secondWidth: _initialWidthValues[1],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.playerName,
                            style: TextStyle(
                              fontFamily: 'EskapadeFrakturW04BlackFamily',
                              color: Colors.white,
                              fontSize: ScreenSize.screenHeight * 0.02 +
                                  ScreenSize.screenWidth * 0.02,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Former chancellor and president cards
          SizedBox(
            height: widget.height + ScreenSize.screenHeight * 0.0225,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    OpacityAnimation(
                      key: _opacityKeys[5],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[5][0],
                      end: _initialOpacityValues[5][1],
                      child: Image.asset(
                        'assets/images/former_chancellor_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[6],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[6][0],
                      end: _initialOpacityValues[6][1],
                      child: Image.asset(
                        'assets/images/former_president_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[7],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[7][0],
                      end: _initialOpacityValues[7][1],
                      child: Image.asset(
                        'assets/images/chancellor_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[8],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[8][0],
                      end: _initialOpacityValues[8][1],
                      child: Image.asset(
                        'assets/images/president_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: widget.width - ScreenSize.screenWidth * 0.09,
            top: ScreenSize.screenHeight * 0.0125,
            child: OpacityAnimation(
              key: _opacityKeys[12],
              duration: const Duration(milliseconds: 500),
              begin: _initialOpacityValues[12][0],
              end: _initialOpacityValues[12][1],
              child: Image.asset(
                'assets/images/not_hitler.png',
                height: ScreenSize.screenHeight * 0.09,
                width: ScreenSize.screenWidth * 0.09,
              ),
            ),
          ),
          // Voting cards
          SizedBox(
            height: widget.height + ScreenSize.screenHeight * 0.0225,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    OpacityAnimation(
                      key: _opacityKeys[9],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[9][0],
                      end: _initialOpacityValues[9][1],
                      child: FlipAnimation(
                        key: _flipAnimationKeys[0],
                        duration: const Duration(milliseconds: 500),
                        firstWidget: Image.asset(
                          'assets/images/ballot_card_back.png',
                          height: ScreenSize.screenHeight * 0.0425,
                          width: ScreenSize.screenWidth * 0.15,
                        ),
                        secondWidget: Image.asset(
                          'assets/images/ballot_yes_card_without_background.png',
                          height: ScreenSize.screenHeight * 0.0425,
                          width: ScreenSize.screenWidth * 0.15,
                        ),
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[10],
                      duration: const Duration(milliseconds: 500),
                      begin: _initialOpacityValues[10][0],
                      end: _initialOpacityValues[10][1],
                      child: FlipAnimation(
                        key: _flipAnimationKeys[1],
                        duration: const Duration(milliseconds: 500),
                        firstWidget: Image.asset(
                          'assets/images/ballot_card_back.png',
                          height: ScreenSize.screenHeight * 0.0425,
                          width: ScreenSize.screenWidth * 0.15,
                        ),
                        secondWidget: Image.asset(
                          'assets/images/ballot_no_card_without_background.png',
                          height: ScreenSize.screenHeight * 0.0425,
                          width: ScreenSize.screenWidth * 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
