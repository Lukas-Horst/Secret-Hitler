// author: Lukas Horst

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';

// Function to get the next president under the player who are alive
int _getNextPresident(int currentPresident, List<int> killedPlayers,
    int playerAmount) {
  currentPresident++;
  currentPresident %= playerAmount;
  while (true) {
    if (killedPlayers.contains(currentPresident)) {
      currentPresident++;
      currentPresident %= playerAmount;
    } else {
      return currentPresident;
    }
  }
}

// Function to update the play state to the chancellor voting
Future<void> chancellorVotingState(WidgetRef ref, int chancellorIndex) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': 1,
      'currentChancellor': chancellorIndex,
    },
  );
}

// Function to update the voting from the player and if all voted change in
// the next state
Future<void> voteForChancellor(WidgetRef ref, int voting,
    int ownPlayerIndex) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  List<int> chancellorVoting = gameState.chancellorVoting;
  // Updating the own voting
  chancellorVoting[ownPlayerIndex] = voting;
  final bool votingFinished = isVotingFinished(chancellorVoting);
  int newState = 1;
  int newElectionTracker = gameState.electionTracker;
  if (votingFinished) {
    newState = _countVoting(chancellorVoting, gameState.electionTracker);
    if (newState != 3) {
      newElectionTracker++;
    } else {
      newElectionTracker = 0;
    }
  }
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': newState,
      'chancellorVoting': chancellorVoting,
      'electionTracker': newElectionTracker,
    },
  );
}

// Function to check if all players has voted
bool isVotingFinished(List<int> chancellorVoting) {
  for (int voting in chancellorVoting) {
    if (voting == 0) {
      return false;
    }
  }
  return true;
}

// Function which counts the voting and returns the next play state
int _countVoting(List<int> chancellorVoting, int electionTracker) {
  int neededVotes = floorDivision(chancellorVoting.length, 2) + 1;
  for (int voting in chancellorVoting) {
    // Yes vote
    if (voting == 2) {
      neededVotes--;
    }
    // The voting was successful
    if (neededVotes == 0) {
      return 3;
    }
  }
  // The vote wasn't successful and it was the third time in a row
  if (electionTracker == 2) {
    return 2;
  }
  return 0;
}

// Function to set all chancellor voting back to 0
Future<void> resetChancellorVoting(WidgetRef ref) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  List<int> chancellorVoting = [];
  for (int i=0; i < gameState.chancellorVoting.length; i++) {
    chancellorVoting.add(0);
  }
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'chancellorVoting': chancellorVoting,
    },
  );
}

// Function when the president discard his card
Future<void> discardCard(WidgetRef ref, int cardIndex) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': 4,
      'discardedPresidentialCard': cardIndex,
    },
  );
}

// Function to play a card
Future<void> playCard(WidgetRef ref, int cardIndex, bool normalPlay) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  bool cardColor = gameState.cardColors[cardIndex];
  int newLiberalBoardCardAmount = gameState.liberalBoardCardAmount;
  int newFascistBoardCardAmount = gameState.fascistBoardCardAmount;
  if (cardColor) {
    newLiberalBoardCardAmount++;
  } else {
    newFascistBoardCardAmount++;
  }
  int newGameState = _getNewGameState(
    cardColor,
    gameState,
    newFascistBoardCardAmount,
  );
  int newDrawPileCardAmount = normalPlay
      ? gameState.drawPileCardAmount - 3
      : gameState.drawPileCardAmount - 1;
  List<bool> newCardColors = List.from(gameState.cardColors);
  // If the draw pile has fewer than 3 card, it will be reshuffled with the card
  // from the discards pile
  if (newDrawPileCardAmount < 3) {
    newDrawPileCardAmount = 14 - newFascistBoardCardAmount - newLiberalBoardCardAmount;
    newCardColors = _shuffleCards(
      newFascistBoardCardAmount,
      newLiberalBoardCardAmount,
      newDrawPileCardAmount,
    );
  // Else the one or 3 cards will be removed from the draw pile
  } else {
    for (int i=0; i < 3; i++) {
      if (normalPlay) {
        newCardColors.removeAt(0);
      } else if (i == 2) {
        newCardColors.removeAt(2);
      }
    }
  }
  int newPresident = gameState.currentPresident;
  int? newFormerPresident;
  int? newFormerChancellor = gameState.currentChancellor;
  if (newGameState == 0) {
    newPresident = _getNextPresident(
      gameState.currentPresident,
      gameState.killedPlayers,
      gameState.chancellorVoting.length,
    );
    newFormerPresident = gameState.currentPresident;
  }
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': newGameState,
      'liberalBoardCardAmount': newLiberalBoardCardAmount,
      'fascistBoardCardAmount': newFascistBoardCardAmount,
      'cardColors': newCardColors,
      'drawPileCardAmount': newDrawPileCardAmount,
      'playedCard': cardIndex,
      'electionTracker': 0,
      'currentPresident': newPresident,
      'currentChancellor': null,
      'formerPresident': newFormerPresident,
      'formerChancellor': newFormerChancellor,
    },
  );
}

// Function to get the new game state based on the played card
int _getNewGameState(bool cardColor, GameState gameState, int fascistBoardCardAmount) {
  int playerAmount = gameState.chancellorVoting.length;
  // If a fascist card was played we need to check if their are any presidential action
  if (!cardColor) {
    // 5 to 6 players
    if (playerAmount < 7) {
      // The President examines the top 3 cards by 3 fascist cards
      if (fascistBoardCardAmount == 3) {
        return 5;
      }
    // 7 to 10 players
    } else {
      // The President investigates a player's identity card
      if ((fascistBoardCardAmount == 1 && playerAmount > 8)
          || fascistBoardCardAmount == 2) {
        return 6;
      // The President pick the next President
      } else if (fascistBoardCardAmount == 3) {
        return 7;
      }
    }
    // The President kills a player
    if (fascistBoardCardAmount== 4 || fascistBoardCardAmount== 5) {
      return 8;
    }
  }
  // The liberal team won
  if (gameState.liberalBoardCardAmount + 1 == 5) {
    return 9;
  // The fascist team won
  } else if (fascistBoardCardAmount == 7) {
    return 10;
  }
  return 0;
}

// Method to shuffle the cards on the draw pile
List<bool> _shuffleCards(int fascistBoardCardAmount, int liberalBoardCardAmount,
    int drawPileCardAmount) {
  int fascistCardAmount = 8 - fascistBoardCardAmount;
  int liberalCardAmount = 6 - liberalBoardCardAmount;
  List<bool> cardColors = [];
  for (int i=0; i < drawPileCardAmount; i++) {
    // If no fascist card is left
    if (fascistCardAmount == 0) {
      cardColors.add(true);
      continue;
      // If no liberal card is left
    } else if (liberalCardAmount == 0) {
      cardColors.add(false);
      continue;
    }
    int cardColor = Random().nextInt(2);
    // Liberal card
    if (cardColor == 1) {
      cardColors.add(true);
      liberalCardAmount--;
      // Fascist card
    } else {
      cardColors.add(false);
      fascistCardAmount--;
    }
  }
  return cardColors;
}