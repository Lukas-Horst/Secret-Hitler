// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

class PlayersAndElection extends StatefulWidget {
  const PlayersAndElection({super.key});

  @override
  State<PlayersAndElection> createState() => _PlayersAndElectionState();
}

class _PlayersAndElectionState extends State<PlayersAndElection> with AutomaticKeepAliveClientMixin {

  final List<GlobalKey<PlayerWidgetState>> _playerWidgetsKeys = [
    GlobalKey<PlayerWidgetState>(),
    GlobalKey<PlayerWidgetState>(),
    GlobalKey<PlayerWidgetState>(),
    GlobalKey<PlayerWidgetState>(),
    GlobalKey<PlayerWidgetState>(),
  ];

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryElevatedButton(text: 'Test', onPressed: () async {
                    for (int i=0; i < 2; i++) {
                      await _playerWidgetsKeys[i].currentState?.changeActionImage(4);
                      _playerWidgetsKeys[i].currentState?.dividerVisibility();
                    }
                  }),
                  const SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlayerWidget(
                        key: _playerWidgetsKeys[0],
                        playerName: 'TestTestTestTestTestTest',
                        height: ScreenSize.screenHeight * 0.075,
                        width: ScreenSize.screenWidth * 0.45,
                      ),
                      PlayerWidget(
                        key: _playerWidgetsKeys[1],
                        playerName: 'Test',
                        height: ScreenSize.screenHeight * 0.075,
                        width: ScreenSize.screenWidth * 0.45,
                      ),
                    ],
                  ),
                ],
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
