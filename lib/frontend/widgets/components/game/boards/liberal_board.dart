// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/board_methods.dart';

class LiberalBoard extends StatefulWidget {

  final int cards;
  final int flippedCards;
  final List<GlobalKey<FlipAnimationState>> cardFlipKeys;

  const LiberalBoard({super.key, required this.cards, required this.cardFlipKeys,
    required this.flippedCards});

  @override
  State<LiberalBoard> createState() => _LiberalBoardState();
}

class _LiberalBoardState extends State<LiberalBoard> {

  List<double> cardPositions = [
    ScreenSize.screenWidth * 0.1675,
    ScreenSize.screenWidth * 0.3,
    ScreenSize.screenWidth * 0.432,
    ScreenSize.screenWidth * 0.5625,
    ScreenSize.screenWidth * 0.6975,
  ];

  List<Widget> boardElements = [
    Image.asset(
    'assets/images/liberal_board.png',
    height: ScreenSize.screenHeight * 0.225,
    width: ScreenSize.screenWidth * 0.98,
    ),
  ];

  @override
  void initState() {
    boardElements = BoardMethods.buildBoard(
      true,
      boardElements,
      widget.cards,
      widget.flippedCards,
      cardPositions,
      widget.cardFlipKeys,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: boardElements,
    );
  }
}
