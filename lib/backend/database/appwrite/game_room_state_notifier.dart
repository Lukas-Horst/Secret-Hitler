// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';

class GameRoomState {
  final Document? gameRoomDocument;

  GameRoomState({required this.gameRoomDocument});
}

class GameRoomStateNotifier extends StateNotifier<GameRoomState> {
  late final DatabaseApi _databaseApi;
  late final Client _client;
  late RealtimeSubscription _subscription;
  bool _isSubscribed = false;
  Document? _gameRoomDocument;

  GameRoomStateNotifier(this._databaseApi, this._client) :super(
      GameRoomState(gameRoomDocument: null));

  // Method to set the game room from the given id
  Future<void> setGameRoom(String gameRoomId) async {
    _gameRoomDocument = await _databaseApi.getDocumentById(
      gameRoomCollectionId,
      gameRoomId,
    );
    state = GameRoomState(gameRoomDocument: _gameRoomDocument);
    _unsubscribeGameRoom();
    _subscribeGameRoom(gameRoomId);
  }

  // Method to subscribe to the given game room
  void _subscribeGameRoom(String gameRoomId) {
    if (!_isSubscribed) {
      _isSubscribed = true;
      Realtime realtime = Realtime(_client);
      _subscription = realtime.subscribe([
        'databases.$appwriteDatabaseId.collections.$gameRoomCollectionId.'
            'documents.$gameRoomId',
      ]);
      _subscription.stream.listen((event) async {
        _gameRoomDocument = await _databaseApi.getDocumentById(
          gameRoomCollectionId,
          gameRoomId,
        );
        state = GameRoomState(gameRoomDocument: _gameRoomDocument);
      });
    }
  }

  // Method to set the game room back to null and unsubscribe the game room
  void resetGameRoom() {
    if (state.gameRoomDocument != null) {
      state = GameRoomState(gameRoomDocument: null);
      _unsubscribeGameRoom();
    }
  }

  // Method to unsubscribe the game room if is active
  void _unsubscribeGameRoom() async {
    if (_isSubscribed) {
      _subscription.close();
      _isSubscribed = false;
    }
  }
}