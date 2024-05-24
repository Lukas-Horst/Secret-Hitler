// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class DrawPile extends StatefulWidget {

  final int cards;

  const DrawPile({super.key, required this.cards});

  @override
  State<DrawPile> createState() => DrawPileState();
}

class DrawPileState extends State<DrawPile> {

  List<Widget> pileElements = [
    Image.asset(
      'assets/images/draw_pile.png',
      height: ScreenSize.screenHeight * 0.15,
      width: ScreenSize.screenWidth * 0.3,
    ),
  ];

  void buildPile() {
    double topScale;
    double leftScale;
    for (int i=0; i < widget.cards; i++) {
      topScale = ScreenSize.screenHeight * (0.0005 * (i+1));
      leftScale = ScreenSize.screenHeight * (0.0005 * (i+1));
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
  }

  void removeCard() {
    setState(() {
      pileElements.removeLast();
    });
  }

  @override
  void initState() {
    buildPile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: pileElements,
    );
  }
}
