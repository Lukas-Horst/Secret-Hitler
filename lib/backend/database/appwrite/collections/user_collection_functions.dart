// author: Lukas Horst

import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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

Future<bool> deleteUser(String userId, Client client) async {
  Functions functions = Functions(client);
  try {
    Execution result = await functions.createExecution(
      functionId: deleteUserFunctionId,
      body: jsonEncode({'userId': '6755cc29000bca9f7f35'}),
      xasync: false,
    );
    // Function call was successful
    if (result.responseStatusCode == 200) {
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