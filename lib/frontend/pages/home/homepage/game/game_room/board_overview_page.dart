// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/fascist_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/liberal_board.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02),
        SizedBox(
          height: ScreenSize.screenHeight * 0.7,
          child: Stack(
            children: [
              Positioned(
                child: FascistBoard(
                  playerAmount: widget.playerAmount,
                  cards: 0,
                  flippedCards: 0,
                  cardFlipKeys: _fascistCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.175,
                child: LiberalBoard(
                  cards: 0,
                  flippedCards: 0,
                  cardFlipKeys: _liberalCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.4,
                child: DrawPile(
                  key: drawPileKey,
                  cards: 2,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.4,
                left: ScreenSize.screenWidth * 0.675,
                child: Image.asset(
                  'assets/images/discard_pile.png',
                  height: ScreenSize.screenHeight * 0.15,
                  width: ScreenSize.screenWidth * 0.3,
                ),
              ),
            ],
          ),
        ),
        PrimaryElevatedButton(text: 'Test', onPressed: () {drawPileKey.currentState?.removeCard();})
      ],
    );
  }
}
