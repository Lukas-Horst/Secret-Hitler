// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';

class BoardMethods{

  // Method to build up the liberal or fascist board with all cards
  static List<Widget> buildBoard(bool isLiberal, List<Widget> boardElements,
      int cards, int flippedCards, List<double> cardPositions,
      List<GlobalKey<FlipAnimationState>> cardFlipKeys) {
    for (int i=0; i < cards; i++) {
      // Deciding if the card is already flipped or not
      bool isFlipped;
      if (i < flippedCards) {
        isFlipped = true;
      } else {
        isFlipped = false;
      }
      addCard(boardElements, cardPositions, isLiberal, isFlipped);
    }
    return boardElements;
  }

  static void addCard(List<Widget> boardElements, List<double> cardPositions,
      bool isLiberal, bool isFlipped) {
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
    if (isFlipped) {
      firstWidget = frontSide;
      secondWidget = backSide;
    } else {
      firstWidget = backSide;
      secondWidget = frontSide;
    }
    int leftCardPosition = isLiberal ? boardElements.length - 3 : boardElements.length - 1;
    boardElements.add(
      Positioned(
        top: ScreenSize.screenHeight * 0.075,
        left: cardPositions[leftCardPosition],
        child: FlipAnimation(
          duration: const Duration(milliseconds: 500),
          firstWidget: firstWidget,
          secondWidget: secondWidget,
        ),
      ),
    );
  }
}