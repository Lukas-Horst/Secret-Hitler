// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';
import 'package:secret_hitler/backend/helper/convertAppwriteData.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';

class GameState {

  int currentPresident;
  int nextPresident;
  int playState;
  List<int> killedPlayers;
  bool regularPresident;
  int? currentChancellor;
  int? formerChancellor;
  int? formerPresident;

  GameState({required this.currentPresident, required this.nextPresident,
    required this.killedPlayers, required this.playState,
    required this.regularPresident, this.currentChancellor,
    this.formerChancellor, this.formerPresident});
}

class GameStateNotifier extends StateNotifier<GameState> {

  int nextPresident = 1;
  late final DatabaseApi _databaseApi;
  late final Client _client;
  late RealtimeSubscription _subscription;
  bool _isSubscribed = false;
  Document? _gameStateDocument;


  GameStateNotifier(this._databaseApi, this._client) :super(
    GameState(currentPresident: 0, nextPresident: 1, killedPlayers: [],
        playState: 0, regularPresident: true)
  );

  // Updated all values of the game state
  void _updateGameStateNotifier() {
    List<int> killedPlayers = convertDynamicToIntList(
        _gameStateDocument!.data['killedPlayers']);
    int currentPresident = _gameStateDocument!.data['currentPresident'];
    int? currentChancellor = _gameStateDocument!.data['currentChancellor'];
    int playState = _gameStateDocument!.data['playState'];
    bool regularPresident = _gameStateDocument!.data['regularPresident'];
    int? formerChancellor = _gameStateDocument!.data['formerChancellor'];
    int? formerPresident = _gameStateDocument!.data['formerPresident'];
    if (regularPresident) {
      nextPresident = getNextPresident(nextPresident, killedPlayers);
    }
    state = GameState(
      currentPresident: currentPresident,
      nextPresident: nextPresident,
      killedPlayers: killedPlayers,
      playState: playState,
      regularPresident: regularPresident,
      currentChancellor: currentChancellor,
      formerChancellor: formerChancellor,
      formerPresident: formerPresident,
    );
  }

  void subscribeGameState(String gameStateId) {
    if (!_isSubscribed) {
      _isSubscribed = true;
      Realtime realtime = Realtime(_client);
      _subscription = realtime.subscribe([
        'databases.$appwriteDatabaseId.collections.$gameStateCollectionId.'
            'documents.$gameStateId',
      ]);
      _subscription.stream.listen((event) async {
        _gameStateDocument = await _databaseApi.getDocumentById(
          gameStateCollectionId,
          gameStateId,
        );
        _updateGameStateNotifier();
      });
    }
  }

  // Method to unsubscribe the game state if is active
  void unsubscribeGameRoom() async {
    if (_isSubscribed) {
      _subscription.close();
      _isSubscribed = false;
    }
  }

}
