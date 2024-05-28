// author: Lukas Horst

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/board_overview_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/fascist_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/liberal_board.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/discard_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/draw_pile.dart';

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

  GlobalKey<DrawPileState> drawPileKey = GlobalKey<DrawPileState>();
  GlobalKey<DiscardPileState> discardPileKey = GlobalKey<DiscardPileState>();

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
    true,  // Left card
    true,  // Middle card
    true,  // Right card
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

  late int drawPileCardAmount;
  int discardPileCardAmount = 0;

  // Method to get one off the playing cards
  Widget _getCard(bool isLiberal, bool isCovered,
      GlobalKey<FlipAnimationState> flipKey) {
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
      key: flipKey,
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
        animatedWidget: _getCard(true, true, _cardFlipKey[cardIndex]),
      );
    } else {
      return const SizedBox();
    }
  }

  // Method to put the given card amount to the draw pile inclusive the 3 cards with animation
  void _updateDrawPile(int cardAmount) {
    // Checking if enough cards are on the draw pile
    if (cardAmount > 2) {
      setState(() {
        drawPileCardAmount = cardAmount - 3;
        for (int i=0; i < 3; i++) {
          _cardVisibility[i] = true;
          _cardTopPosition[i][0] = BoardOverviewPositions.constantTopPositions[2]
              + (13 - drawPileCardAmount - i) * ScreenSize.screenHeight * 0.001;
          _cardLeftPosition[i][0] = BoardOverviewPositions.constantLeftPositions[0]
              + (13 - drawPileCardAmount - i) * ScreenSize.screenWidth * 0.002;
          _cardTopPosition[i][1] = BoardOverviewPositions.constantTopPositions[3];
          _cardLeftPosition[i][1] = BoardOverviewPositions.constantLeftPositions[2];
        }
      });
    }
  }

  // Drawing 3 card from the draw pile
  Future<void> _drawCards() async {
    for (int i=0; i < 3; i++) {
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
    List<String> cardPositions = ['Left', '', 'Right'];
    // Changing the move animation
    for (int i=0; i < 3; i++) {
      if (_cardVisibility[i]) {
        await _updateAnimation('BottomCenter',
            'BottomCenter${cardPositions[i]}', i, 750);
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
    // Spread out the card
    for (int i=0; i < 3; i++) {
      _cardMovingKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    // Flip the cards
    for (int i=0; i < 3; i++) {
      _cardFlipKey[i].currentState?.animate();
    }
  }

  // Method to update the moving animations of the given card
  Future<void> _updateAnimation(String start, String end, int cardIndex,
      int duration) async {
    Map<String, List<double>> positions = {
      'DiscardPile': [BoardOverviewPositions.constantTopPositions[2], BoardOverviewPositions.constantLeftPositions[1], 10],
      'BottomCenter': [BoardOverviewPositions.constantTopPositions[3], BoardOverviewPositions.constantLeftPositions[2], 0],
      'BottomCenterLeft': [BoardOverviewPositions.constantTopPositions[3] + ScreenSize.screenHeight * 0.005, BoardOverviewPositions.constantLeftPositions[2] - ScreenSize.screenWidth * 0.13, -10],
      'BottomCenterRight': [BoardOverviewPositions.constantTopPositions[3] + ScreenSize.screenHeight * 0.005, BoardOverviewPositions.constantLeftPositions[2] + ScreenSize.screenWidth * 0.13, 10],
      'LiberalBoard': [BoardOverviewPositions.constantTopPositions[1], BoardOverviewPositions.liberalBoardLeftPositions[drawPileKey.currentState!.pileElements.length-1]],
      'FascistBoard': [BoardOverviewPositions.constantTopPositions[0], BoardOverviewPositions.fascistBoardLeftPositions[discardPileKey.currentState!.pileElements.length-1]],
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
      _cardVisibility[cardIndex] = true;
    });
  }

  @override
  void initState() {
    _updateDrawPile(4);
    super.initState();
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
                  playerAmount: widget.playerAmount,
                  cards: 1,
                  flippedCards: 0,
                  cardFlipKeys: _fascistCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.175,
                child: LiberalBoard(
                  cards: 1,
                  flippedCards: 0,
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
                        key: drawPileKey,
                        cards: drawPileCardAmount,
                      ),
                      CustomTextButton(
                        text: 'Test',
                        textStyle: TextStyle(),
                        onTap: () async {
                          await _drawCards();
                          await _discoverCards();
                        },
                      ),
                      DiscardPile(
                        key: discardPileKey,
                        cards: discardPileCardAmount,
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
