// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/helper/convertAppwriteData.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_navigation.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

// Function to create the game state to the game room document
Future<void> createGameStateDocument(WidgetRef ref, Document gameRoomDocument) async {
  final databaseApi = ref.watch(databaseApiProvider);
  await databaseApi.createDocument(
    gameStateId,
    gameRoomDocument.$id,
    {
      'playerOrder': [],
      'playerNames': [],
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
  // Shuffling the players
  for (final user in gameRoomDocument.data['users']) {
    users[user['\$id']] = user['userName'];
    playerOrder.add(user['\$id']);
  }
  playerOrder.shuffle();
  for (String userId in playerOrder) {
    playerNames.add(users[userId]!);
  }
  await databaseApi.updateDocument(
    gameStateId,
    gameRoomDocument.$id,
    {
      'isActive': true,
      'playerNames': playerNames,
      'playerOrder': playerOrder,
    },
  );
  Document? gameStateDocument = await databaseApi.getDocumentById(
    gameStateId,
    gameRoomDocument.$id,
  );
  LoadingSpin.closeLoadingSpin(context);
  if (gameStateDocument == null) {return;}
  gameRoomStateNotifier.resetGameRoom();
  closePage(context, 1);
  newPage(context, GameRoomNavigation(gameStateDocument: gameStateDocument));
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