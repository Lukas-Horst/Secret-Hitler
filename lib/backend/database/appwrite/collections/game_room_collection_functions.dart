// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_state_collection_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_navigation.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/waiting_room/waiting_room_page.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

// Function to create a waiting room in the database
Future<void> createWaitingRoom(WidgetRef ref, String password,
    int playerAmount, BuildContext context) async {
  LoadingSpin.openLoadingSpin(context);
  final databaseApi = ref.watch(databaseApiProvider);
  final userState = ref.watch(userStateProvider);
  int roomNumber = await getFreeRoomNumber(ref);
  await databaseApi.createDocument(
    gameRoomCollectionId,
    null,
    {
      'password': password,
      'roomNumber': roomNumber,
      'users': [userState.user!.$id],
      'playerAmount': playerAmount,
      'host': userState.user!.$id
    },
  );
  // Getting the created game room document and return it
  Document? gameRoomDocument = await databaseApi.getDocumentByAttribute(
      gameRoomCollectionId,
      queries: [Query.equal('roomNumber', roomNumber)]
  );
  LoadingSpin.closeLoadingSpin(context);
  if (gameRoomDocument == null) {return;}
  await createGameStateDocument(ref, gameRoomDocument);
  closePage(context, 1);
  newPage(context, WaitingRoom(gameRoomDocument: gameRoomDocument,));
}

// Function which checks whats the next unused number to name a new room
Future<int> getFreeRoomNumber(WidgetRef ref) async {
  final databaseApi = ref.watch(databaseApiProvider);
  DocumentList? documents = await databaseApi.listDocuments(gameRoomCollectionId);
  // List all current used room numbers
  List<int> roomNumbers = documents!.documents.map((document) {
    return document.data['roomNumber'] as int;
  }).toList();
  roomNumbers.sort();
  int unusedNumber = 1;
  // Count upwards and see if the number is in the list
  for (int roomNumber in roomNumbers) {
    if (roomNumber == unusedNumber) {
      unusedNumber++;
    } else {
      return unusedNumber;
    }
  }
  return unusedNumber;
}

// Function to get a waiting room by the given id
Future<Document?> getWaitingRoom(WidgetRef ref, String roomId,
    BuildContext? context) async {
  if (context != null) {
    LoadingSpin.openLoadingSpin(context);
  }
  final databaseApi = ref.watch(databaseApiProvider);
  Document? gameRoomDocument = await databaseApi.getDocumentById(
    gameRoomCollectionId,
    roomId,
  );
  if (context != null) {
    LoadingSpin.closeLoadingSpin(context);
  }
  return gameRoomDocument;
}

// Function to join the waiting room and add the user to the player list
Future<void> joinWaitingRoom(WidgetRef ref, Document gameRoomDocument,
    BuildContext context, int popPages) async {
  LoadingSpin.openLoadingSpin(context);
  final databaseApi = ref.watch(databaseApiProvider);
  Document? gameStateDocument = await databaseApi.getDocumentById(
    gameStateCollectionId,
    gameRoomDocument.$id,
  );
  bool rejoinGame = false;
  if (checkGameState(ref, gameStateDocument)) {
    rejoinGame = checkRejoinGame(ref, gameStateDocument);
    if (!rejoinGame) {
      LoadingSpin.closeLoadingSpin(context);
      CustomSnackbar.showSnackbar(
        AppLanguage.getLanguageData()['There is currently an active game'],
        Colors.red,
        const Duration(seconds: 3),
      );
      return;
    }
  } else {
    // Checking if the waiting room is full
    if (gameRoomDocument.data['users'].length >= gameRoomDocument.data['playerAmount']) {
      if (!_checkRejoinGameRoom(ref, gameRoomDocument)) {
        LoadingSpin.closeLoadingSpin(context);
        CustomSnackbar.showSnackbar(
          AppLanguage.getLanguageData()['The waiting room is full'],
          Colors.red,
          const Duration(seconds: 3),
        );
        return;
      }
    }
  }
  final qrCodeStateNotifier = ref.watch(qrCodeProvider.notifier);
  qrCodeStateNotifier.updateCodeInformation(null);
  if (!rejoinGame) {
    await _updateUserList(ref, gameRoomDocument, true);
  }
  LoadingSpin.closeLoadingSpin(context);
  closePage(context, popPages);
  if (rejoinGame) {
    newPage(context, GameRoomNavigation(gameStateDocument: gameStateDocument!));
  } else {
    newPage(context, WaitingRoom(gameRoomDocument: gameRoomDocument,));
  }
}

// Function to leave a waiting room and update the host or close the waiting room
Future<void> leaveWaitingRoom(WidgetRef ref, Document gameRoomDocument,
    BuildContext? context) async {
  if (context != null) {
    LoadingSpin.openLoadingSpin(context);
  }
  await _updateUserList(ref, gameRoomDocument, false);
  if (context != null) {
    LoadingSpin.closeLoadingSpin(context);
    closePage(context, 1);
  }
}

// Function to add or delete a user from a waiting room
Future<void> _updateUserList(WidgetRef ref, Document gameRoomDocument,
    bool addUser) async {
  final databaseApi = ref.read(databaseApiProvider);
  final userState = ref.read(userStateProvider);
  User currentUser = userState.user!;
  final users = gameRoomDocument.data['users'];
  bool isHost = isCurrentUserHost(ref, gameRoomDocument);
  // Checking if the user is currently in the user list of the waiting room
  bool userInWaitingRoom = false;
  int count = -1;
  for (final user in users) {
    count++;
    try {
      if (user['\$id'] == currentUser.$id) {
        userInWaitingRoom = true;
        break;
      }
    } catch(e) {print(e);}
  }
  if (!userInWaitingRoom) {
    if (addUser) {
      users.add(currentUser.$id);
    }
  } else if (!addUser) {
    users.removeAt(count);
  }
  String? newHost = currentUser.$id;
  // Updating the host if the host leave the game
  if (!addUser && isHost) {
    newHost = null;
    for (final user in users) {
      if (!user['guest']) {
        newHost = user['\$id'];
      }
    }
  }
  if (users.length > 0 && newHost != null) {
    await databaseApi.updateDocument(gameRoomCollectionId, gameRoomDocument.$id, {
      'users': users,
      'host': newHost,
    });
  } else {
    // If no user is in the waiting room, it will be closed
    await databaseApi.deleteDocument(gameRoomCollectionId, gameRoomDocument.$id);
  }
}

// Function to check if the player can rejoin if the waiting room is full
bool _checkRejoinGameRoom(WidgetRef ref, Document gameRoomDocument) {
  final userState = ref.watch(userStateProvider);
  final String userId = userState.user!.$id;
  for (dynamic user in gameRoomDocument.data['users']) {
    if (user['\$id'] == userId) {
      return true;
    }
  }
  return false;
}

// Function to check if the current user is the host
bool isCurrentUserHost(WidgetRef ref, Document gameRoomDocument) {
  final userState = ref.watch(userStateProvider);
  User currentUser = userState.user!;
  return gameRoomDocument.data['host'] == currentUser.$id;
}