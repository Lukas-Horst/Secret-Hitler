// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/players_and_election/player_widget.dart';

// Backend class for the players and election page but also for the roles page
class PlayersAndElectionBackend{

  List<GlobalKey<PlayerWidgetState>> playerWidgetsOpacityKeys = [];
  List<GlobalKey<FlipAnimationState>> ballotCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),  // No Card
    GlobalKey<FlipAnimationState>(),  // Yes Card
  ];

  late GlobalKey<PlayersAndElectionState> playersAndElectionFrontendKey;
  late BoardOverviewBackend boardOverviewBackend;
  late int playerAmount;
  late List<String> playerNames;  // All names of the players
  late List<String> playerOrder;  // Decides the presidential order
  late List<String> playerRoles;  // All roles of the players
  late List<String> ownRole;  // The own role
  late List<String> hitler;  // The player name (Index 0) and the id (Index 1) of hitler
  late List<String> teamMembers;  // The names of all team members
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
    _setOwnRole();
    _setTeamMembers();
  }

  // Set a list with the membership (Index 0) and the secret role (Index 1)
  void _setOwnRole() {
    List<String> ownRole = [];
    String secretRole = playerRoles[position];
    Random random = Random();
    if (secretRole == 'Hitler') {
      ownRole.add('Fascist');
      ownRole.add(secretRole);
    } else {
      ownRole.add(secretRole);
      if (secretRole == 'Fascist') {
        ownRole.add('${secretRole}_${random.nextInt(3) + 1}');
      } else {
        ownRole.add('${secretRole}_${random.nextInt(4) + 1}');
      }
    }
    this.ownRole = ownRole;
  }

  // Searching all team members and adding their name in the team members list
  // and setting hitler
  void _setTeamMembers() {
    List<String> teamMembers = [];
    List<String> hitler = [];
    for (int i=0; i < playerRoles.length; i++) {
      if (i != position && playerRoles[i] == ownRole[0]
          && playerRoles[i] != 'Hitler') {
        teamMembers.add(playerNames[i]);
      } else if (playerRoles[i] == 'Hitler') {
        hitler.add(playerNames[i]);
        hitler.add(playerOrder[i]);
      }
    }
    this.hitler = hitler;
    this.teamMembers = teamMembers;
  }
}