// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/helper/convertAppwriteData.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_navigation.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

// Function to create the game state to the game room document
Future<void> createGameStateDocument(WidgetRef ref, Document gameRoomDocument) async {
  final databaseApi = ref.watch(databaseApiProvider);
  await databaseApi.createDocument(
    gameStateCollectionId,
    gameRoomDocument.$id,
    {
      'playerOrder': [],
      'playerNames': [],
      'playerRoles': [],
      'killedPlayers': [],
      'chancellorVoting': [],
    },
  );
  await databaseApi.updateDocument(
    gameRoomCollectionId,
    gameRoomDocument.$id,
    {'gameState': gameRoomDocument.$id},
  );
}

// Function to update the game state for a new game
Future<void> startGame(WidgetRef ref, Document gameRoomDocument,
    BuildContext context, GameRoomStateNotifier gameRoomStateNotifier) async {
  LoadingSpin.openLoadingSpin(context);
  final databaseApi = ref.watch(databaseApiProvider);
  Map<String, String> users = {};
  List<String> playerOrder = [];
  List<String> playerNames = [];
  List<String> playerRoles = ['Hitler'];
  List<int> chancellorVoting = [];
  final int playerAmount = gameRoomDocument.data['users'].length;
  final int fascistAmount = _getFascistAmount(playerAmount);
  // Adding the roles
  for (int i=0; i < fascistAmount; i++) {
    playerRoles.add('Fascist');
  }
  for (int i=0; i < playerAmount - (fascistAmount + 1); i++) {
    playerRoles.add('Liberal');
  }
  playerRoles.shuffle();
  // Shuffling the players
  for (final user in gameRoomDocument.data['users']) {
    users[user['\$id']] = user['userName'];
    playerOrder.add(user['\$id']);
  }
  playerOrder.shuffle();
  for (String userId in playerOrder) {
    playerNames.add(users[userId]!);
    chancellorVoting.add(0);
  }
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameRoomDocument.$id,
    {
      'isActive': true,
      'playerNames': playerNames,
      'playerOrder': playerOrder,
      'playerRoles': playerRoles,
      'chancellorVoting': chancellorVoting,
    },
  );
  Document? gameStateDocument = await databaseApi.getDocumentById(
    gameStateCollectionId,
    gameRoomDocument.$id,
  );
  LoadingSpin.closeLoadingSpin(context);
  if (gameStateDocument == null) {return;}
  gameRoomStateNotifier.resetGameRoom();
  closePage(context, 1);
  newPage(context, GameRoomNavigation(gameStateDocument: gameStateDocument));
}

// Returns the amount of fascist based on the player amount
int _getFascistAmount(int playerAmount) {
  if (playerAmount < 7) {
    return 1;
  } else if (playerAmount < 9) {
    return 2;
  } else {
    return 3;
  }
}

// Function to check if the user can rejoin the game
bool checkRejoinGame(WidgetRef ref, Document? gameStateDocument) {
  if (gameStateDocument == null) {return false;}
  final userState = ref.watch(userStateProvider);
  final String userId = userState.user!.$id;
  final List<String> playerOrder = convertDynamicToStringList(
      gameStateDocument.data['playerOrder']);
  return playerOrder.contains(userId);
}

// Function to check if the game is currently active
bool checkGameState(WidgetRef ref, Document? gameStateDocument) {
  if (gameStateDocument == null) {return false;}
  return gameStateDocument.data['isActive'];
}