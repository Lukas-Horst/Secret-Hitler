// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Methods for the card piles
class PileMethods{

  static void buildPile(List<Widget> pileElements, int cards, bool isDiscardPile) {
    for (int i=0; i < cards; i++) {
      addCard(pileElements, isDiscardPile);
    }
  }

  static void addCard(List<Widget> pileElements, bool isDiscardPile) {
    double topScale = ScreenSize.screenHeight * (0.001 * pileElements.length);
    double leftScale;
    if (isDiscardPile) {
      leftScale = ScreenSize.screenWidth * (-0.002 * (pileElements.length - 1));
    } else {
      leftScale = ScreenSize.screenWidth * (0.002 * (pileElements.length - 1));
    }
    Widget card = Positioned(
      top: ScreenSize.screenHeight * 0.03 - topScale,
      left: ScreenSize.screenWidth * 0.095 - leftScale,
      child: Image.asset(
        'assets/images/policy_card_back.png',
        height: ScreenSize.screenHeight * 0.08,
        width: ScreenSize.screenWidth * 0.115,
      ),
    );
    pileElements.add(card);
  }

  static void removeCard(List<Widget> pileElements) {
    pileElements.removeLast();
  }

}