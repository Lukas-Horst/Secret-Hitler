// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';
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

  const PlayerWidget({super.key, required this.playerName, required this.height,
    required this.width, required this.index, required this.ownPlayerIndex});

  @override
  ConsumerState<PlayerWidget> createState() => PlayerWidgetState();
}

class PlayerWidgetState extends ConsumerState<PlayerWidget> {

  final List<GlobalKey<OpacityAnimationState>> _opacityKeys = [
    GlobalKey<OpacityAnimationState>(), // Visibility of the whole widget
    GlobalKey<OpacityAnimationState>(), // Visibility of execution image
    GlobalKey<OpacityAnimationState>(), // Visibility of the special election image
    GlobalKey<OpacityAnimationState>(), // Visibility of the investigate loyalty image
    GlobalKey<OpacityAnimationState>(), // Visibility of the voting icon
    GlobalKey<OpacityAnimationState>(), // Visibility of the former chancellor card
    GlobalKey<OpacityAnimationState>(), // Visibility of the former president card
    GlobalKey<OpacityAnimationState>(), // Visibility of the chancellor card
    GlobalKey<OpacityAnimationState>(), // Visibility of the president card
    GlobalKey<OpacityAnimationState>(), // Visibility of the yes card
    GlobalKey<OpacityAnimationState>(), // Visibility of the no card
  ];

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
  late bool _isFormerChancellor;
  late bool _isFormerPresident;
  late bool _isChancellor;
  late bool _isPresident;
  bool _wasFormerPresident = false;
  bool _wasFormerChancellor = false;
  bool _wasPresident = false;
  bool _wasChancellor = false;
  bool _voting = false;
  bool _isDead = false;
  bool _voted = false;
  bool _votingCardFlipped = false;

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
        begin: 0.0,
        end: 1.0,
        child: Center(
          child: Padding(
            padding: i != 1
                ? EdgeInsets.only(right: widget.width * 0.03)
                : const EdgeInsets.all(0),
            child: IconButton(
              onPressed: () {
                final gameStateNotifier = ref.read(gameStateProvider);
                int playState = gameStateNotifier.playState;
                // Changing from playState=0 to playState=1
                if (playState == 0) {
                  chancellorVotingState(ref, widget.index);
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
      _opacityKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 850));
      _sizeAnimationKeys[0].currentState?.animate();
      _dividerVisible = false;
      await Future.delayed(const Duration(milliseconds: 1350));
      _opacityKeys[_activeExecutivePower].currentState?.animate();
    } else {
      _sizeAnimationKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1500));
      _opacityKeys[0].currentState?.animate();
      _dividerVisible = true;
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  // Method to change the image of the next action
  Future<void> _changeActionImage(int executivePower) async {
    _activeExecutivePower = executivePower;
    if (!_dividerVisible) {
      _opacityKeys[_activeExecutivePower].currentState?.animate();
    }
  }

  // Method to make the yes or no card visible
  Future<void> _setVotingCard(bool voting) async {
    if (!_voted) {
      _voted = true;
      // Yes card
      if (voting) {
        _opacityKeys[9].currentState?.animate();
        // No card
      } else {
        _opacityKeys[10].currentState?.animate();
      }
      _chancellorVoting = voting;
    }
    await Future.delayed(const Duration(milliseconds: 500));
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

  // Method to make the (former) chancellor or president card visible
  Future<void> _setGovernmentCard() async {
    // Former chancellor card
    if (_isFormerChancellor) {
      _opacityKeys[5].currentState?.animate();
      _wasFormerChancellor = true;
    }
    // Former president card
    if (_isFormerPresident) {
      _opacityKeys[6].currentState?.animate();
      _wasFormerPresident = true;
    }
    // Chancellor card
    if (_isChancellor) {
      _opacityKeys[7].currentState?.animate();
      _wasChancellor = true;
    }
    // President card
    if (_isPresident) {
      _opacityKeys[8].currentState?.animate();
      _wasPresident = true;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Method to hide the current (former) chancellor or president card if is it visible
  Future<void> _hideGovernmentCard() async {
    if (_wasFormerChancellor) {
      _opacityKeys[5].currentState?.animate();
      _wasFormerChancellor = false;
    }
    if (_wasFormerPresident) {
      _opacityKeys[6].currentState?.animate();
      _wasFormerPresident = false;
    }
    if (_wasChancellor) {
      _opacityKeys[7].currentState?.animate();
      _wasChancellor = false;
    }
    if (_wasPresident) {
      _opacityKeys[8].currentState?.animate();
      _wasPresident = false;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Method to check if we have any changes of the government
  void _checkForGovernmentChanges() async {
    if (_isPresident != _wasPresident || _isChancellor != _wasChancellor
        || _isFormerPresident != _wasFormerPresident ||
        _isFormerChancellor != _wasFormerChancellor) {
      await _hideGovernmentCard();
      await _setGovernmentCard();
    }
  }

  // Method to check if the president has any action to take
  void _checkForPresidentActions(int playState, int currentPresident) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Deciding the chancellor if the player is the current president
    if (currentPresident == widget.ownPlayerIndex) {
      if (playState == 0 && !_isPresident && !_voting && !_isFormerPresident
          && !_isFormerChancellor && !_isDead) {
        _voting = true;
        _changeActionImage(4);
        await _dividerVisibility();
      } else if (playState != 0 && _voting && !_isFormerPresident
          && !_isFormerChancellor && !_isDead) {
        _voting = false;
        await _dividerVisibility();
      }
    }
    // Voting phase for the chancellor
    if (playState == 1) {

    }
  }

  // Method to check the chancellor voting of all players
  Future<void> _checkChancellorVoting(List<int> chancellorVoting,
      int playState) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (chancellorVoting[widget.index] != 0) {
      await _setVotingCard(chancellorVoting[widget.index] == 2);
    }
    if (isVotingFinished(chancellorVoting) && !_votingCardFlipped && _voted) {
      await _flipVotingCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    _isPresident = gameState.currentPresident == widget.index;
    _isChancellor = gameState.currentChancellor == widget.index;
    _isFormerPresident = gameState.formerPresident == widget.index;
    _isFormerChancellor = gameState.formerChancellor == widget.index;
    _isDead = gameState.killedPlayers.contains(widget.index);
    _checkForGovernmentChanges();
    _checkForPresidentActions(
      gameState.playState,
      gameState.currentPresident,
    );
    _checkChancellorVoting(gameState.chancellorVoting, gameState.playState);
    return SizedBox(
      height: widget.height + ScreenSize.screenHeight * 0.0225,
      child: Stack(
        children: [
          SizedBox(
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
                  begin: 0.0,
                  end: 1.0,
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
                  firstWidth: widget.width,
                  secondHeight: widget.height,
                  secondWidth: widget.width/1.4 - 1.5,
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
                      begin: 0.0,
                      end: 1.0,
                      child: Image.asset(
                        'assets/images/former_chancellor_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[6],
                      duration: const Duration(milliseconds: 500),
                      begin: 0.0,
                      end: 1.0,
                      child: Image.asset(
                        'assets/images/former_president_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[7],
                      duration: const Duration(milliseconds: 500),
                      begin: 0.0,
                      end: 1.0,
                      child: Image.asset(
                        'assets/images/chancellor_card.png',
                        height: ScreenSize.screenHeight * 0.0425,
                        width: ScreenSize.screenWidth * 0.375,
                      ),
                    ),
                    OpacityAnimation(
                      key: _opacityKeys[8],
                      duration: const Duration(milliseconds: 500),
                      begin: 0.0,
                      end: 1.0,
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
                      begin: 0.0,
                      end: 1.0,
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
                      begin: 0.0,
                      end: 1.0,
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
