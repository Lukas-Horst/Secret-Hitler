// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/players_and_election_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';
import 'package:secret_hitler/frontend/widgets/components/transformed_widgets/angle_widget.dart';

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
    int topPosition = 0;
    bool evenPlayerAmount = backend.playerAmount % 2 == 0;
    for (int i=0; i < backend.playerAmount; i++) {
      late int leftPosition;
      // Middle position
      if (i == 0 && !evenPlayerAmount) {
        leftPosition = 2;
      // Left position
      } else if (i % 2 == 0) {
        leftPosition = 0;
      // Right Position
      } else {
        leftPosition = 1;
        if (!evenPlayerAmount) {
          topPosition++;
        }
      }
      playerWidgets.add(
        Positioned(
          top: playerWidgetTopPositions[topPosition],
          left: playerWidgetPositions[leftPosition],
          child: PlayerWidget(
            key: backend.playerWidgetsOpacityKeys[i],
            playerName: 'TestTestTestTestTestTest',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenWidth * 0.45,
          ),
        ),
      );
      if (i % 2 == 1 && evenPlayerAmount) {
        topPosition++;
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
    super.build(context);
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02,),
        SizedBox(
          height: ScreenSize.screenHeight * 0.86,
          width: ScreenSize.screenWidth * 0.96,
          child: Stack(
            children: [
              Stack(
                children: _getPlayerWidgets(),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.1,
                child: AngleWidget(
                  angleDegree: -15,
                  child: FlipAnimation(
                    key: backend.ballotCardFlipKeys[0],
                    duration: const Duration(),
                    firstWidget: Image.asset(
                      'assets/images/ballot_card_back.png',
                      height: ScreenSize.screenHeight * 0.1,
                      width: ScreenSize.screenWidth * 0.3,
                    ),
                    secondWidget: Image.asset(
                      'assets/images/ballot_no_card_without_background.png',
                      height: ScreenSize.screenHeight * 0.1,
                      width: ScreenSize.screenWidth * 0.3,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.73,
                left: ScreenSize.screenWidth * 0.58,
                child: AngleWidget(
                  angleDegree: 15,
                  child: FlipAnimation(
                    key: backend.ballotCardFlipKeys[1],
                    duration: const Duration(),
                    firstWidget: Image.asset(
                      'assets/images/ballot_card_back.png',
                      height: ScreenSize.screenHeight * 0.1,
                      width: ScreenSize.screenWidth * 0.3,
                    ),
                    secondWidget: Image.asset(
                      'assets/images/ballot_yes_card_without_background.png',
                      height: ScreenSize.screenHeight * 0.1,
                      width: ScreenSize.screenWidth * 0.3,
                    ),
                  ),
                ),
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
