// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';

// Function to create a user in the user collection of the database
Future<bool> createUser(WidgetRef ref) async {
  final databaseApi = ref.watch(databaseApiProvider);
  final userState = ref.watch(userStateProvider);
  bool response = await databaseApi.createDocument(
    userCollectionId,
    userState.user!.$id,
    {
      'online': false,
      'userName': userState.user!.name,
      'lastActive': DateTime.now().toIso8601String(),
      'guest': false,
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