// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/rotation_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/pile_methods.dart';

class DrawPile extends StatefulWidget {

  final int cards;

  const DrawPile({super.key, required this.cards});

  @override
  State<DrawPile> createState() => DrawPileState();
}

class DrawPileState extends State<DrawPile> {

  final List<GlobalKey<RotationAnimationState>> _drawPileRotationKeys = [];

  List<Widget> pileElements = [
    Image.asset(
      'assets/images/draw_pile.png',
      height: ScreenSize.screenHeight * 0.15,
      width: ScreenSize.screenWidth * 0.3,
    ),
  ];

  // Method to get the next unused rotation key
  GlobalKey<RotationAnimationState> getNextRotationKey() {
    return _drawPileRotationKeys[pileElements.length - 1];
  }

  // Method to start a shuffle animation for all cards
  Future<void> shuffle() async {
    for (int i=0; i < pileElements.length - 1; i++) {
      _drawPileRotationKeys[i].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 15));
    }
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  void initState() {
    // Adding the rotationKeys
    for (int i=0; i < 14; i++) {
      _drawPileRotationKeys.add(GlobalKey<RotationAnimationState>());
    }
    PileMethods.buildPile(pileElements, widget.cards, false, _drawPileRotationKeys);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: pileElements,
    );
  }
}
