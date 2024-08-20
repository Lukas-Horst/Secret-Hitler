// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/players_and_election_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

class PlayerWidgetStack extends StatefulWidget {

  final PlayersAndElectionBackend backend;

  const PlayerWidgetStack({super.key, required this.backend});

  @override
  State<PlayerWidgetStack> createState() => _PlayerWidgetStackState();
}

class _PlayerWidgetStackState extends State<PlayerWidgetStack> {

  late PlayersAndElectionBackend backend;

  // Method to build the player widgets clockwise
  List<Widget> _getPlayerWidgets() {
    List<Widget> playerWidgets = [];
    int topPosition = 0;
    bool evenPlayerAmount = backend.playerAmount % 2 == 0;
    int rows = ceilingDivision(backend.playerAmount, 2);
    bool downwards = true;  // Variable to decide if the top position goes down or up
    for (int i=0; i < backend.playerAmount; i++) {
      late int leftPosition;
      // Middle position
      if (i == 0 && !evenPlayerAmount) {
        leftPosition = 2;
      // Right Position
      } else if (downwards) {
        leftPosition = 1;
      // Left Position
      } else {
        leftPosition = 0;
      }
      playerWidgets.add(
        Positioned(
          top: playerWidgetTopPositions[topPosition],
          left: playerWidgetPositions[leftPosition],
          child: PlayerWidget(
            key: backend.playerWidgetsKeys[i],
            playerName: backend.playerNames[i],
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenWidth * 0.45,
            index: i,
            ownPlayerIndex: backend.ownPlayerIndex,
            backend: backend,
          ),
        ),
      );
      if (topPosition < rows - 1) {
        if (downwards) {
          topPosition++;
        } else {
          topPosition--;
        }
      } else if (downwards) {
        downwards = false;
      } else {
        topPosition--;
      }
    }
    return playerWidgets;
  }

  @override
  void initState() {
    backend = widget.backend;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getPlayerWidgets(),
    );
  }
}
