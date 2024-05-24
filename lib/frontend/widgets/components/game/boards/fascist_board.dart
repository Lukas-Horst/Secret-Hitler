// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/boards/board_methods.dart';

class FascistBoard extends StatefulWidget {

  final int cards;
  final int flippedCards;
  final List<GlobalKey<FlipAnimationState>> cardFlipKeys;
  final int playerAmount;

  const FascistBoard({super.key, required this.playerAmount,
    required this.cards, required this.flippedCards,
    required this.cardFlipKeys});

  @override
  State<FascistBoard> createState() => _FascistBoardState();
}

class _FascistBoardState extends State<FascistBoard> {

  List<Widget> boardElements = [];
  List<double> cardPositions = [
    ScreenSize.screenWidth * 0.1035,
    ScreenSize.screenWidth * 0.235,
    ScreenSize.screenWidth * 0.3665,
    ScreenSize.screenWidth * 0.499,
    ScreenSize.screenWidth * 0.6325,
    ScreenSize.screenWidth * 0.765,
  ];

  // Get the right fascist board based on the player amount
  String getFascistBoard(int playerAmount) {
    if (playerAmount < 7) {
      return 'fascist_board_5_6_players';
    } else if (playerAmount < 9) {
      return 'fascist_board_7_8_players';
    } else {
      return 'fascist_board_9_10_players';
    }
  }

  @override
  void initState() {
    boardElements.add(
      Image.asset(
        'assets/images/${getFascistBoard(widget.playerAmount)}.png',
        height: ScreenSize.screenHeight * 0.225,
        width: ScreenSize.screenWidth * 0.98,
      ),
    );
    BoardMethods.buildBoard(
      false,
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
