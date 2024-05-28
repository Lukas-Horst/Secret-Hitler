// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/game/piles/pile_methods.dart';

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

  @override
  void initState() {
    PileMethods.buildPile(pileElements, widget.cards, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: pileElements,
    );
  }
}