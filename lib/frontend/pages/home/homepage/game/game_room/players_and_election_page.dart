// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/players_and_election_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

class PlayersAndElection extends StatefulWidget {

  final PlayersAndElectionBackend backend;

  const PlayersAndElection({super.key, required this.backend});

  @override
  State<PlayersAndElection> createState() => PlayersAndElectionState();
}

class PlayersAndElectionState extends State<PlayersAndElection> with AutomaticKeepAliveClientMixin {

  late PlayersAndElectionBackend backend;

  // Method to build the player widgets
  List<Widget> _getPlayerWidgets() {
    List<Widget> playerWidgets = [];
    int topPosition = -1;
    for (int i=0; i < backend.playerAmount; i++) {
      late int leftPosition;
      // Middle position
      if (i == 0 || (i == backend.playerAmount - 1 && backend.playerAmount % 2 == 0)) {
        leftPosition = 2;
        topPosition++;
      // Left position
      } else if (i % 2 == 0) {
        leftPosition = 0;
      // Right Position
      } else {
        leftPosition = 1;
        topPosition++;
      }
      playerWidgets.add(
        MovingAnimation(
          key: backend.playerWidgetsMovingKeys[i],
          duration: const Duration(milliseconds: 0),
          firstTopPosition: PlayersAndElectionConstants.playerWidgetTopPositions[topPosition],
          firstLeftPosition: PlayersAndElectionConstants.playerWidgetLeftPositions[leftPosition],
          secondTopPosition: ScreenSize.screenHeight * 0,
          secondLeftPosition: ScreenSize.screenWidth * 0,
          child: PlayerWidget(
            key: backend.playerWidgetsOpacityKeys[i],
            playerName: 'TestTestTestTestTestTest',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenWidth * 0.45,
          ),
        ),
      );
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
    super.build(context);
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02,),
        SizedBox(
          height: ScreenSize.screenHeight * 0.8,
          width: ScreenSize.screenWidth * 0.96,
          child: Stack(
            children: [
              MovingAnimation(
                duration: const Duration(milliseconds: 0),
                firstTopPosition: PlayersAndElectionConstants.playerWidgetTopPositions[6],
                firstLeftPosition: PlayersAndElectionConstants.playerWidgetLeftPositions[2],
                secondTopPosition: PlayersAndElectionConstants.playerWidgetTopPositions[6],
                secondLeftPosition: PlayersAndElectionConstants.playerWidgetLeftPositions[2],
                child: Image.asset(
                  'assets/images/president_card.png',
                  height: ScreenSize.screenHeight * 0.05,
                  width: ScreenSize.screenWidth * 0.45,
                ),
              ),
              MovingAnimation(
                duration: const Duration(milliseconds: 0),
                firstTopPosition: PlayersAndElectionConstants.playerWidgetTopPositions[7],
                firstLeftPosition: PlayersAndElectionConstants.playerWidgetLeftPositions[2],
                secondTopPosition: PlayersAndElectionConstants.playerWidgetTopPositions[7],
                secondLeftPosition: PlayersAndElectionConstants.playerWidgetLeftPositions[2],
                child: Image.asset(
                  'assets/images/chancellor_card.png',
                  height: ScreenSize.screenHeight * 0.05,
                  width: ScreenSize.screenWidth * 0.45,
                ),
              ),
              Stack(
                children: _getPlayerWidgets(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
