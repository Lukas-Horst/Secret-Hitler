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
  List<int> chancellorVoting;
  int electionTracker;
  int fascistBoardCardAmount;
  int liberalBoardCardAmount;
  int drawPileCardAmount;
  List<bool> cardColors;
  int? currentChancellor;
  int? formerChancellor;
  int? formerPresident;
  int? discardedPresidentialCard;

  GameState({required this.currentPresident, required this.nextPresident,
    required this.killedPlayers, required this.playState,
    required this.regularPresident, required this.chancellorVoting,
    required this.electionTracker, required this.fascistBoardCardAmount,
    required this.liberalBoardCardAmount, required this.drawPileCardAmount,
    required this.cardColors, this.currentChancellor, this.formerChancellor,
    this.formerPresident, this.discardedPresidentialCard});
}

class GameStateNotifier extends StateNotifier<GameState> {

  int nextPresident = 1;
  late final DatabaseApi _databaseApi;
  late final Client _client;
  late RealtimeSubscription _subscription;
  bool _isSubscribed = false;
  Document? gameStateDocument;
  bool _init = true;

  GameStateNotifier(this._databaseApi, this._client) :super(
    GameState(
      currentPresident: 0,
      nextPresident: 1,
      killedPlayers: [],
      playState: 0,
      regularPresident: true,
      chancellorVoting: [0, 0, 0, 0, 0],
      electionTracker: 0,
      fascistBoardCardAmount: 0,
      liberalBoardCardAmount: 0,
      drawPileCardAmount: 14,
      cardColors: [],
    )
  );

  // Updated all values of the game state
  void _updateGameStateNotifier() {
    try {
      List<int> killedPlayers = convertDynamicToIntList(
        gameStateDocument!.data['killedPlayers'],);
      int currentPresident = gameStateDocument!.data['currentPresident'];
      int? currentChancellor = gameStateDocument!.data['currentChancellor'];
      int playState = gameStateDocument!.data['playState'];
      bool regularPresident = gameStateDocument!.data['regularPresident'];
      int? formerChancellor = gameStateDocument!.data['formerChancellor'];
      int? formerPresident = gameStateDocument!.data['formerPresident'];
      List<int> chancellorVoting = convertDynamicToIntList(
        gameStateDocument!.data['chancellorVoting'],);
      int electionTracker = gameStateDocument!.data['electionTracker'];
      int fascistBoardCardAmount = gameStateDocument!.data['fascistBoardCardAmount'];
      int liberalBoardCardAmount = gameStateDocument!.data['liberalBoardCardAmount'];
      int drawPileCardAmount = gameStateDocument!.data['drawPileCardAmount'];
      List<bool> cardColors = convertDynamicToBoolList(
        gameStateDocument!.data['cardColors'],
      );
      int? discardedPresidentialCard = gameStateDocument!.data['discardedPresidentialCard'];
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
        chancellorVoting: chancellorVoting,
        electionTracker: electionTracker,
        fascistBoardCardAmount: fascistBoardCardAmount,
        liberalBoardCardAmount: liberalBoardCardAmount,
        drawPileCardAmount: drawPileCardAmount,
        cardColors: cardColors,
        discardedPresidentialCard: discardedPresidentialCard,
      );
    } catch(e) {print(e);}
  }

  void subscribeGameState(String gameStateId) async {
    if (_init) {
      _init = false;
      gameStateDocument = await _databaseApi.getDocumentById(
        gameStateCollectionId,
        gameStateId,
      );
      _updateGameStateNotifier();
    }
    if (!_isSubscribed) {
      _isSubscribed = true;
      Realtime realtime = Realtime(_client);
      _subscription = realtime.subscribe([
        'databases.$appwriteDatabaseId.collections.$gameStateCollectionId.'
            'documents.$gameStateId',
      ]);
      _subscription.stream.listen((event) async {
        gameStateDocument = await _databaseApi.getDocumentById(
          gameStateCollectionId,
          gameStateId,
        );
        _updateGameStateNotifier();
      });
    }
  }

  // Method to unsubscribe the game state if is active
  void unsubscribeGameRoom() async {
    _init = true;
    if (_isSubscribed) {
      _subscription.close();
      _isSubscribed = false;
    }
  }

}
