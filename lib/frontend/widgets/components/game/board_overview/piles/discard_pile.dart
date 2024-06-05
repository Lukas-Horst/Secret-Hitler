// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/pile_functions.dart';

class DiscardPile extends StatefulWidget {

  final int cards;

  const DiscardPile({super.key, required this.cards});

  @override
  State<DiscardPile> createState() => DiscardPileState();
}

class DiscardPileState extends State<DiscardPile> {

  List<Widget> pileElements = [
    Image.asset(
      'assets/images/discard_pile.png',
      height: ScreenSize.screenHeight * 0.15,
      width: ScreenSize.screenWidth * 0.3,
    ),
  ];

  @override
  void initState() {
    buildPile(pileElements, widget.cards, true, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: pileElements,
    );
  }
}
