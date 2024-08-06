// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

class PlayersAndElectionBackend{

  List<GlobalKey<PlayerWidgetState>> playerWidgetsOpacityKeys = [];
  List<GlobalKey<FlipAnimationState>> ballotCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),  // No Card
    GlobalKey<FlipAnimationState>(),  // Yes Card
  ];

  late GlobalKey<PlayersAndElectionState> playersAndElectionFrontendKey;
  late BoardOverviewBackend boardOverviewBackend;
  late int playerAmount;
  late List<String> playerNames;
  late List<String> playerOrder;
  late List<String> playerRoles;
  late int position;  // The position of the player in the lists
  late String id;
  PlayersAndElectionBackend(this.playersAndElectionFrontendKey,
      this.boardOverviewBackend, this.playerNames, this.playerOrder, this.id,
      this.playerRoles) {
    playerAmount = boardOverviewBackend.playerAmount;
    for (int i=0; i < playerAmount; i++) {
      playerWidgetsOpacityKeys.add(GlobalKey<PlayerWidgetState>());
    }
    position = playerOrder.indexOf(id);
  }

}