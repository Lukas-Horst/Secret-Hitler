// author: Lukas Horst

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/board_overview_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/board_methods.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/fascist_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/liberal_board.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/discard_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/draw_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/pile_methods.dart';

class BoardOverview extends StatefulWidget {

  final int playerAmount;

  const BoardOverview({super.key, required this.playerAmount});

  @override
  State<BoardOverview> createState() => _BoardOverviewState();
}

class _BoardOverviewState extends State<BoardOverview> {

  final List<GlobalKey<FlipAnimationState>> _liberalCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
  ];

  final List<GlobalKey<FlipAnimationState>> _fascistCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
  ];

  final GlobalKey<DrawPileState> _drawPileKey = GlobalKey<DrawPileState>();
  final GlobalKey<DiscardPileState> _discardPileKey = GlobalKey<DiscardPileState>();
  final GlobalKey<FascistBoardState> _fascistBoardKey = GlobalKey<FascistBoardState>();
  final GlobalKey<LiberalBoardState> _liberalBoardKey = GlobalKey<LiberalBoardState>();

  final List<GlobalKey<MovingAnimationState>> _cardMovingKey = [
    GlobalKey<MovingAnimationState>(),  // Left card
    GlobalKey<MovingAnimationState>(),  // Middle card
    GlobalKey<MovingAnimationState>(),  // Right card
  ];

  final List<GlobalKey<FlipAnimationState>> _cardFlipKey = [
    GlobalKey<FlipAnimationState>(),  // Left card
    GlobalKey<FlipAnimationState>(),  // Middle card
    GlobalKey<FlipAnimationState>(),  // Right card
  ];

  final List<bool> _cardVisibility = [
    false,  // Left card
    false,  // Middle card
    false,  // Right card
  ];

  final List<List<double>> _cardTopPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
  ];

  final List<List<double>> _cardLeftPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
  ];

  final List<List<double>> _rotationValues = [
    [0.0, -10],  // Left card
    [0.0, -10],  // Middle card
    [0.0, -10],  // Right card
  ];

  final List<Duration> _durationValues = [
    const Duration(milliseconds: 1000),  // Left card
    const Duration(milliseconds: 1000),  // Middle card
    const Duration(milliseconds: 1000),  // Right card
  ];

  final List<bool> _cardColor = [
    // True is liberal (blue) and false fascist (red)
    false,  // Left card
    true,  // Middle card
    true,  // Right card
  ];

  int _drawPileCardAmount = 14;
  int _discardPileCardAmount = 0;
  int _fascistBoardCardAmount = 0;
  int _fascistBoardFlippedCards = 0;
  int _liberalBoardCardAmount = 0;
  int _liberalBoardFlippedCards = 0;

  // Method to get one off the playing cards
  Widget _getCard(bool isLiberal, bool isCovered, int cardIndex) {
    Widget firstWidget;
    Widget secondWidget;
    String cardName;
    if (isLiberal) {
      cardName = 'liberal';
    } else {
      cardName = 'fascist';
    }
    Widget backSide = Image.asset(
      'assets/images/policy_card_back.png',
      height: ScreenSize.screenHeight * 0.08,
      width: ScreenSize.screenWidth * 0.115,
    );
    Widget frontSide = Image.asset(
      'assets/images/policy_card_${cardName}_without_background.png',
    );
    if (isCovered) {
      firstWidget = backSide;
      secondWidget = frontSide;
    } else {
      firstWidget = frontSide;
      secondWidget = backSide;
    }
    return FlipAnimation(
      key: _cardFlipKey[cardIndex],
      duration: const Duration(milliseconds: 600),
      firstWidget: firstWidget,
      secondWidget: secondWidget,
    );
  }

  // Method to return a playing card if active
  Widget _getPlayingCards(bool isCardActive, int cardIndex) {
    if (isCardActive) {
      return MovingAnimation(
        key: _cardMovingKey[cardIndex],
        duration: _durationValues[cardIndex],
        firstTopPosition: _cardTopPosition[cardIndex][0],
        firstLeftPosition: _cardLeftPosition[cardIndex][0],
        firstRotationPosition: _rotationValues[cardIndex][0],
        secondTopPosition: _cardTopPosition[cardIndex][1],
        secondLeftPosition: _cardLeftPosition[cardIndex][1],
        secondRotationPosition: _rotationValues[cardIndex][1],
        firstHeight: BoardOverviewPositions.cardHeights[0],
        firstWidth: BoardOverviewPositions.cardWidth,
        secondHeight: BoardOverviewPositions.cardHeights[1],
        secondWidth: BoardOverviewPositions.cardWidth,
        rotatingDuration: const Duration(milliseconds: 500),
        animatedWidget: _getCard(_cardColor[cardIndex], true, cardIndex),
      );
    } else {
      return const SizedBox();
    }
  }

  // Method to put the given card amount to the draw pile inclusive the 3 cards with animation
  Future<void> _updateDrawPile() async {
    // Checking if enough cards are on the draw pile
    if (_drawPileCardAmount > 2) {
      for (int i=2; i > -1; i--) {
        _drawPileCardAmount--;
        await _updateAnimation('DrawPile', 'BottomCenter', i, 1000);
      }
      for (int i=0; i < 3; i++) {
        _cardVisibility[i] = true;
        if (true) {
          setState(() {
            PileMethods.removeCard(_drawPileKey.currentState!.pileElements);
          });
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // Drawing 3 card from the draw pile
  Future<void> _drawCards() async {
    for (int i=2; i > -1; i--) {
      _drawCard(i);
      await Future.delayed(const Duration(milliseconds: 150));
    }
    await Future.delayed(const Duration(milliseconds: 900));
  }

  // Draw the given card
  void _drawCard(int cardIndex) async {
    _cardMovingKey[cardIndex].currentState?.animate();
    await Future.delayed(const Duration(milliseconds: 500));
    _cardMovingKey[cardIndex].currentState?.rotation();
  }

  // Method to discover the playing cards
  Future<void> _discoverCards() async {
    List<String> cardPositions = ['Left', 'Right', ''];
    int count = 0;
    // Changing the move animation
    for (int i=0; i < 3; i++) {
      if (_cardVisibility[i]) {
        await _updateAnimation('BottomCenter',
            'BottomCenter${cardPositions[count]}', i, 750);
        count++;
      }
    }
    // Spread out the card
    for (int i=0; i < 3; i++) {
      _cardMovingKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    // Flip the cards
    for (int i=0; i < 3; i++) {
      _cardFlipKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // Method to cover the playing cards
  Future<void> _coverCards() async {
    // Fold in the cards
    for (int i=0; i < 3; i++) {
      _cardMovingKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    // Flip the cards
    for (int i=0; i < 3; i++) {
      _cardFlipKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // Method to update the moving animations of the given card
  Future<void> _updateAnimation(String start, String end, int cardIndex,
      int duration) async {
    Map<String, List<double>> positions = {
      'DrawPile': [BoardOverviewPositions.constantTopPositions[2] + (13 - _drawPileCardAmount) * ScreenSize.screenHeight * 0.001,
        BoardOverviewPositions.constantLeftPositions[0] + (13 - _drawPileCardAmount) * ScreenSize.screenWidth * 0.002, -10],
      'DiscardPile': [BoardOverviewPositions.constantTopPositions[2] + (13 - _discardPileCardAmount) * ScreenSize.screenHeight * 0.001,
        BoardOverviewPositions.constantLeftPositions[1] - (13 - _discardPileCardAmount) * ScreenSize.screenWidth * 0.002, 10],
      'BottomCenter': [BoardOverviewPositions.constantTopPositions[3],
        BoardOverviewPositions.constantLeftPositions[2], 0],
      'BottomCenterLeft': [BoardOverviewPositions.constantTopPositions[3] + ScreenSize.screenHeight * 0.005,
        BoardOverviewPositions.constantLeftPositions[2] - ScreenSize.screenWidth * 0.13, -10],
      'BottomCenterRight': [BoardOverviewPositions.constantTopPositions[3] + ScreenSize.screenHeight * 0.005,
        BoardOverviewPositions.constantLeftPositions[2] + ScreenSize.screenWidth * 0.13, 10],
      'LiberalBoard': [BoardOverviewPositions.constantTopPositions[1],
        BoardOverviewPositions.liberalBoardLeftPositions[_liberalBoardCardAmount],
        -5 + (_liberalBoardCardAmount * 2.5)],
      'FascistBoard': [BoardOverviewPositions.constantTopPositions[0],
        BoardOverviewPositions.fascistBoardLeftPositions[_fascistBoardCardAmount],
        -6 + (_fascistBoardCardAmount * 2.5)],
    };
    setState(() {
      _cardVisibility[cardIndex] = false;
    });
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      _cardTopPosition[cardIndex] = [positions[start]![0], positions[end]![0]];
      _cardLeftPosition[cardIndex] = [positions[start]![1], positions[end]![1]];
      _rotationValues[cardIndex] = [0, positions[end]![2]];
      _durationValues[cardIndex] = Duration(milliseconds: duration);
      if (start != 'DrawPile') {
        _cardVisibility[cardIndex] = true;
      }
    });
    if (start != 'DrawPile') {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // Method to discard a playing card
  Future<void> _discard(int cardIndex) async {
    _discardPileCardAmount++;
    await _updateAnimation('BottomCenter',
        'DiscardPile', cardIndex, 1000);
    _cardMovingKey[cardIndex].currentState?.animate();
    await Future.delayed(const Duration(milliseconds: 500));
    _cardMovingKey[cardIndex].currentState?.rotation();
    await Future.delayed(const Duration(milliseconds: 500));
    // Replacing the animated card with a normal card
    setState(() {
      PileMethods.addCard(_discardPileKey.currentState!.pileElements, true);
      _cardVisibility[cardIndex] = false;
    });
  }

  Future<void> playCard(int cardIndex) async {
    String boardColor = _cardColor[cardIndex] ? 'LiberalBoard' : 'FascistBoard';
    await _updateAnimation('BottomCenter',
        boardColor, cardIndex, 1500);
    _cardMovingKey[cardIndex].currentState?.animate();
    _cardMovingKey[cardIndex].currentState?.size();
    await Future.delayed(const Duration(milliseconds: 1000));
    _cardMovingKey[cardIndex].currentState?.rotation();
    await Future.delayed(const Duration(milliseconds: 750));
    _cardFlipKey[cardIndex].currentState?.animate();
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      if (_cardColor[cardIndex]) {
        _liberalBoardCardAmount++;
        _liberalBoardFlippedCards++;
        BoardMethods.addCard(
          _liberalBoardKey.currentState!.boardElements,
          _liberalBoardKey.currentState!.cardPositions,
          true,
          true,
        );
      } else {
        _fascistBoardCardAmount++;
        _fascistBoardFlippedCards++;
        BoardMethods.addCard(
          _fascistBoardKey.currentState!.boardElements,
          _fascistBoardKey.currentState!.cardPositions,
          false,
          true,
        );
      }
      _cardVisibility[cardIndex] = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 50));
    await _updateDrawPile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02),
        SizedBox(
          height: ScreenSize.screenHeight * 0.8,
          child: Stack(
            children: [
              Positioned(
                child: FascistBoard(
                  key: _fascistBoardKey,
                  playerAmount: widget.playerAmount,
                  cards: _fascistBoardCardAmount,
                  flippedCards: _fascistBoardFlippedCards,
                  cardFlipKeys: _fascistCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.175,
                child: LiberalBoard(
                  key: _liberalBoardKey,
                  cards: _liberalBoardCardAmount,
                  flippedCards: _liberalBoardFlippedCards,
                  cardFlipKeys: _liberalCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.4,
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DrawPile(
                        key: _drawPileKey,
                        cards: _drawPileCardAmount,
                      ),
                      CustomTextButton(
                        text: 'Test',
                        textStyle: TextStyle(),
                        onTap: () async {
                          await _drawCards();
                          await _discoverCards();
                          await _coverCards();
                          await _discard(2);
                          await _discoverCards();
                          await _coverCards();
                          await _discard(0);
                          await playCard(1);
                          await _updateDrawPile();
                        },
                      ),
                      DiscardPile(
                        key: _discardPileKey,
                        cards: _discardPileCardAmount,
                      ),
                    ],
                  ),
                ),
              ),
              // The 3 or 2 cards to play
              // Left card
              _getPlayingCards(_cardVisibility[0], 0),
              // Middle card
              _getPlayingCards(_cardVisibility[1], 1),
              // Right card
              _getPlayingCards(_cardVisibility[2], 2),
            ],
          ),
        ),
      ],
    );
  }
}
