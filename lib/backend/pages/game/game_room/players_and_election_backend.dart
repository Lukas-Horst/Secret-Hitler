// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

class PlayersAndElectionBackend{

  List<GlobalKey<PlayerWidgetState>> playerWidgetsOpacityKeys = [];
  List<GlobalKey<MovingAnimationState>> playerWidgetsMovingKeys = [];

  late GlobalKey<PlayersAndElectionState> playersAndElectionFrontendKey;
  late BoardOverviewBackend boardOverviewBackend;
  late int playerAmount;
  late List<String> playerNames;
  PlayersAndElectionBackend(this.playersAndElectionFrontendKey,
      this.boardOverviewBackend, this.playerNames) {
    playerAmount = boardOverviewBackend.playerAmount;
    for (int i=0; i < playerAmount; i++) {
      playerWidgetsOpacityKeys.add(GlobalKey<PlayerWidgetState>());
      playerWidgetsMovingKeys.add(GlobalKey<MovingAnimationState>());
    }
  }

}