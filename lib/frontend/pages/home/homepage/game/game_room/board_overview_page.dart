// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';

class BoardOverview extends StatefulWidget {

  final int playerAmount;

  const BoardOverview({super.key, required this.playerAmount});

  @override
  State<BoardOverview> createState() => _BoardOverviewState();
}

class _BoardOverviewState extends State<BoardOverview> {

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/${getFascistBoard(widget.playerAmount)}.png',
          height: ScreenSize.screenHeight * 0.225,
          width: ScreenSize.screenWidth * 0.98,
        ),
        Image.asset(
          'assets/images/liberal_board.png',
          height: ScreenSize.screenHeight * 0.225,
          width: ScreenSize.screenWidth * 0.98,
        ),
      ],
    );
  }
}
