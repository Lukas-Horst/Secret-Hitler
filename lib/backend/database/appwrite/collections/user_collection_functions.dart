// author: Lukas Horst

import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';

// Function to create a user in the user collection of the database
Future<bool> createUser(WidgetRef ref, bool isGuest) async {
  final databaseApi = ref.read(databaseApiProvider);
  final userState = ref.read(userStateProvider);
  // Checking if the user already exists in the database
  if (await databaseApi.getDocumentById(userCollectionId, userState.user!.$id) != null) {
    return false;
  }
  bool response = await databaseApi.createDocument(
    userCollectionId,
    userState.user!.$id,
    {
      'online': true,
      'userName': userState.user!.name,
      'lastActive': DateTime.now().toIso8601String(),
      'guest': isGuest,
      'provider': userState.provider != null,
    },
  );
  return response;
}

// Function to set the online status of the user to true or false and update the
// last activity date
Future<bool> updateOnlineStatus(WidgetRef ref, bool online) async {
  final databaseApi = ref.watch(databaseApiProvider);
  final userState = ref.watch(userStateProvider);
  bool response = false;
  if (userState.user != null) {
    response = await databaseApi.updateDocument(
      userCollectionId,
      userState.user!.$id,
      {
        'online': online,
        'lastActive': DateTime.now().toIso8601String(),
      },
    );
  }
  return response;
}

// Function to update the username
Future<bool> updateUserName(WidgetRef ref, String userName) async {
  final databaseApi = ref.watch(databaseApiProvider);
  final userState = ref.watch(userStateProvider);
  final authApi = ref.watch(authApiProvider);
  bool response = false;
  response = await authApi.updateUserName(userName);
  if (!response) {return response;}
  response = await databaseApi.updateDocument(
    userCollectionId,
    userState.user!.$id,
    {
      'userName': userName,
    },
  );
  return response;
}

Future<bool> deleteUser(String userId, WidgetRef ref) async {
  final authApi = ref.read(authApiProvider);
  final userNotifier = ref.read(userStateProvider.notifier);
  final databaseApi = ref.read(databaseApiProvider);
  Functions functions = Functions(authApi.getClient());
  try {
    Document? userDocument = await databaseApi.getDocumentById(userCollectionId, userId);
    if (userDocument != null) {
      final gameRooms = userDocument.data['gameRooms'];
      // Removing the player from all game rooms he is in
      for (final gameRoomMap in gameRooms) {
        final gameRoomDocument = await databaseApi.getDocumentById(gameRoomCollectionId, gameRoomMap['\$id']);
        await leaveWaitingRoom(ref, gameRoomDocument!, null);
      }
      // Then deleting the user document
      bool response = await databaseApi.deleteDocument(userCollectionId, userId);
      if (!response) {
        return false;
      }
    }
    Execution result = await functions.createExecution(
      functionId: deleteUserFunctionId,
      body: jsonEncode({'userId': userId, 'projectId': appwriteProjectId}),
      xasync: false,
    );
    // Function call was successful
    if (result.responseStatusCode == 200) {
      // The user will be logged out
      await authApi.logout(null);
      userNotifier.checkUserStatus();
      userNotifier.changeVerificationState();
      final responseBody = jsonDecode(result.responseBody);
      if (responseBody['message'] == 'Benutzer erfolgreich gelöscht.') {
        return true;
      }
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}