// author: Lukas Horst

// Function to create a new game room
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

Future<Document?> createGameRoom(WidgetRef ref, String password, int playerAmount,
    BuildContext context) async {
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
  return gameRoomDocument;
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
