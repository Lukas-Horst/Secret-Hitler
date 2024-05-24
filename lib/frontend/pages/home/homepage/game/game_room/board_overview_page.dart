// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
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

  GlobalKey<DrawPileState> drawPileKey = GlobalKey<DrawPileState>();
  GlobalKey<DiscardPileState> discardPileKey = GlobalKey<DiscardPileState>();
  GlobalKey<MovingAnimationState> middleCardKey = GlobalKey<MovingAnimationState>();

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
                        cards: 14,
                      ),
                      CustomTextButton(
                        text: 'Test',
                        textStyle: TextStyle(),
                        onTap: () {
                          middleCardKey.currentState?.animate();
                        },
                      ),
                      DiscardPile(
                        key: discardPileKey,
                        cards: 14,
                      ),
                    ],
                  ),
                ),
              ),
              MovingAnimation(
                key: middleCardKey,
                duration: const Duration(milliseconds: 500),
                firstTopPosition: ScreenSize.screenHeight * 0.65,
                firstLeftPosition:  ScreenSize.screenWidth * 0.43,
                firstRotationPosition: 0.0,
                secondTopPosition: ScreenSize.screenHeight * 0.7,
                secondLeftPosition: ScreenSize.screenWidth * 0.5,
                secondRotationPosition: pi / 4,
                animatedWidget: Image.asset(
                  'assets/images/policy_card_liberal_without_background.png',
                  height: ScreenSize.screenHeight * 0.08,
                  width: ScreenSize.screenWidth * 0.115,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
