// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';

class BoardMethods{

  // Method to build up the liberal or fascist board with all cards
  static List<Widget> buildBoard(bool isLiberal, List<Widget> boardElements,
      int cards, int flippedCards, List<double> cardPositions,
      List<GlobalKey<FlipAnimationState>> cardFlipKeys) {
    late Widget firstWidget;
    late Widget secondWidget;
    late String cardName;
    if (isLiberal) {
      cardName = 'liberal';
    } else {
      cardName = 'fascist';
    }
    Widget backSide = Image.asset(
      'assets/images/policy_card_back.png',
      height: ScreenSize.screenHeight * 0.075,
      width: ScreenSize.screenWidth * 0.115,
    );
    Widget frontSide = Image.asset(
      'assets/images/policy_card_${cardName}_without_background.png',
      height: ScreenSize.screenHeight * 0.075,
      width: ScreenSize.screenWidth * 0.115,
    );
    for (int i=0; i < cards; i++) {
      // Deciding if the card is already flipped or not
      if (i < flippedCards) {
        firstWidget = frontSide;
        secondWidget = backSide;
      } else {
        firstWidget = backSide;
        secondWidget = frontSide;
      }
      boardElements.add(
        Positioned(
          top: ScreenSize.screenHeight * 0.075,
          left: cardPositions[i],
          child: FlipAnimation(
            key: cardFlipKeys[i],
            duration: const Duration(milliseconds: 500),
            firstWidget: firstWidget,
            secondWidget: secondWidget,
          ),
        ),
      );
    }
    return boardElements;
  }

}