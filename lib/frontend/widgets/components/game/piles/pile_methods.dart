// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/rotation_animation.dart';

// Methods for the card piles
class PileMethods{

  static void buildPile(List<Widget> pileElements, int cards, bool isDiscardPile,
      List<GlobalKey<RotationAnimationState>>? drawPileRotationKeys) {
    for (int i=0; i < cards; i++) {
      if (drawPileRotationKeys != null) {
        addCard(pileElements, isDiscardPile, drawPileRotationKeys[i]);
      } else {
        addCard(pileElements, isDiscardPile, null);
      }
    }
  }

  static void addCard(List<Widget> pileElements, bool isDiscardPile,
      GlobalKey<RotationAnimationState>? rotationKey) {
    double topScale = ScreenSize.screenHeight * (0.001 * pileElements.length);
    double leftScale;
    if (isDiscardPile) {
      leftScale = ScreenSize.screenWidth * (-0.002 * (pileElements.length - 1));
    } else {
      leftScale = ScreenSize.screenWidth * (0.002 * (pileElements.length - 1));
    }
    // Deciding if the rotation goes left or right
    double rotation = (pileElements.length % 2 == 0)
        ? 360
        : -360;
    Widget card = Positioned(
      top: ScreenSize.screenHeight * 0.03 - topScale,
      left: ScreenSize.screenWidth * 0.095 - leftScale,
      child: RotationAnimation(
        key: rotationKey,
        duration: const Duration(milliseconds: 750),
        firstRotationPosition: 0,
        secondRotationPosition: rotation,
        animatedWidget: Image.asset(
          'assets/images/policy_card_back.png',
          height: ScreenSize.screenHeight * 0.08,
          width: ScreenSize.screenWidth * 0.115,
        ),
      ),
    );
    pileElements.add(card);
  }

  static void removeCard(List<Widget> pileElements) {
    if (pileElements.length > 1) {
      pileElements.removeLast();
    }
  }

}