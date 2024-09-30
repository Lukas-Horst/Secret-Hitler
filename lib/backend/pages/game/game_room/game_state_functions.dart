// author: Lukas Horst

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/page_view.dart';

bool _presidentialActionButton = false;  // Bool to avoid double execution of a function

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
Future<bool> chancellorVotingState(WidgetRef ref, int chancellorIndex) async {
  if (!_presidentialActionButton) {
    _presidentialActionButton = true;
    final databaseApi = ref.read(databaseApiProvider);
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    bool response = await databaseApi.updateDocument(
      gameStateCollectionId,
      gameStateNotifier.gameStateDocument!.$id,
      {
        'playState': 1,
        'currentChancellor': chancellorIndex,
      },
    );
    _presidentialActionButton = false;
    return response;
  } else {
    return false;
  }
}

// Function to update the voting from the player and if all voted, change in
// the next state
Future<bool> voteForChancellor(WidgetRef ref, int voting,
    int ownPlayerIndex, int hitler) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  List<int> chancellorVoting = gameState.chancellorVoting;
  // Updating the own voting
  chancellorVoting[ownPlayerIndex] = voting;
  final bool votingFinished = isVotingFinished(chancellorVoting, gameState.killedPlayers);
  int newState = 1;
  int newElectionTracker = gameState.electionTracker;
  if (votingFinished) {
    newState = _countVoting(chancellorVoting, gameState.electionTracker,
        gameState.killedPlayers.length);
    // If the voting wasn't successful
    if (newState != 3) {
      newElectionTracker++;
      // Else the election tracker resets
    } else {
      if (gameState.fascistBoardCardAmount != 5) {
        newElectionTracker = 0;
      }
    }
  }
  int newPresident = gameState.currentPresident;
  int? newChancellor = gameState.currentChancellor;
  int? newFormerPresident = gameState.formerPresident;
  int? newFormerChancellor = gameState.formerChancellor;
  if (newState == 0) {
    newChancellor = null;
    newPresident = _getNextPresident(
      gameState.regularPresident
          ? newPresident
          : gameState.formerPresident!,
      gameState.killedPlayers,
      gameState.chancellorVoting.length,
    );
  }
  // The voting was successful
  if (votingFinished && newState > 2) {
    // Hitler danger
    if (gameState.fascistBoardCardAmount >= 3) {
      // If hitler is successfully voted the fascist win
      if (newChancellor == hitler) {
        newState = 10;
        newElectionTracker = gameState.electionTracker;
      // Else the chancellor is confirmed not hitler
      } else {
        if (!gameState.notHitlerConfirmed.contains(newChancellor!)) {
          gameState.notHitlerConfirmed.add(newChancellor);
        }
      }
    }
  }
  if (newState == 2) {
    newChancellor = null;
  }
  // Checking if we must block the progress on the board overview page
  if (newElectionTracker != gameState.electionTracker) {
    checkProgressBlocks(ref, newElectionTracker: newElectionTracker);
  }
  return await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': newState,
      'chancellorVoting': chancellorVoting,
      'electionTracker': newElectionTracker,
      'currentPresident': newPresident,
      'currentChancellor': newChancellor,
      'formerPresident': newFormerPresident,
      'formerChancellor': newFormerChancellor,
      'regularPresident': newState == 0 ? true : gameState.regularPresident,
      'notHitlerConfirmed': gameState.notHitlerConfirmed,
    },
  );
}

// Function to check if all players has voted
bool isVotingFinished(List<int> chancellorVoting, List<int> killedPlayers) {
  for (int i=0; i < chancellorVoting.length; i++) {
    int voting = chancellorVoting[i];
    if (voting == 0 && !killedPlayers.contains(i)) {
      return false;
    }
  }
  return true;
}

// Function which counts the voting and returns the next play state
int _countVoting(List<int> chancellorVoting, int electionTracker,
    int killedPlayersAmount) {
  int neededVotes = floorDivision(
      chancellorVoting.length - killedPlayersAmount, 2) + 1;
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
Future<bool> resetChancellorVoting(WidgetRef ref) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final gameState = ref.read(gameStateProvider);
  List<int> chancellorVoting = [];
  for (int i=0; i < gameState.chancellorVoting.length; i++) {
    chancellorVoting.add(0);
  }
  return await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'chancellorVoting': chancellorVoting,
    },
  );
}

// Function when the president discard his card
Future<bool> discardCard(WidgetRef ref, int cardIndex) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  return await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': 4,
      'discardedPresidentialCard': cardIndex,
    },
  );
}

// Function to play a card
Future<bool> playCard(WidgetRef ref, int cardIndex, bool normalPlay) async {
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
    newLiberalBoardCardAmount,
  );
  int newDrawPileCardAmount = normalPlay
      ? gameState.drawPileCardAmount - 3
      : gameState.drawPileCardAmount - 1;
  List<bool> newCardColors = List.from(gameState.cardColors);
  newCardColors = _checkDrawPile(newDrawPileCardAmount,
      newCardColors, normalPlay, newFascistBoardCardAmount,
      newLiberalBoardCardAmount);
  if (newDrawPileCardAmount < 3) {
    newDrawPileCardAmount = 14 - newFascistBoardCardAmount - newLiberalBoardCardAmount;
  }
  int newPresident = gameState.currentPresident;
  int? newFormerPresident;
  int? newFormerChancellor = gameState.currentChancellor;
  if (newGameState == 0) {
    newPresident = _getNextPresident(
      gameState.regularPresident
          ? newPresident
          : gameState.formerPresident!,
      gameState.killedPlayers,
      gameState.chancellorVoting.length,
    );
    newFormerPresident = gameState.currentPresident;
  }
  if (!normalPlay) {
    newFormerChancellor = null;
    newFormerPresident = null;
  }
  return await databaseApi.updateDocument(
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
      'regularPresident': true,
      'veto': 0,
    },
  );
}

// Function to get the new game state based on the played card
int _getNewGameState(bool cardColor, GameState gameState,
    int fascistBoardCardAmount, int liberalBoardCardAmount) {
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
  if (liberalBoardCardAmount == 5) {
    return 9;
  // The fascist team won
  } else if (fascistBoardCardAmount == 6) {
    return 10;
  }
  return 0;
}

// Method to check if the draw pile should be reshuffled and to update the
// attributes for the draw pile
List<bool> _checkDrawPile(int drawPileCardAmount, List<bool> cardColors,
    bool normalPlay, int fascistBoardCardAmount, int liberalBoardCardAmount) {
  // If the draw pile has fewer than 3 card, it will be reshuffled with the card
  // from the discards pile
  if (drawPileCardAmount < 3) {
    drawPileCardAmount = 14 - fascistBoardCardAmount - liberalBoardCardAmount;
    cardColors = shuffleCards(
      fascistBoardCardAmount,
      liberalBoardCardAmount,
      drawPileCardAmount,
    );
  // Else the one or 3 cards will be removed from the draw pile
  } else {
    for (int i=0; i < 3; i++) {
      if (normalPlay) {
        cardColors.removeAt(0);
      } else if (i == 2) {
        cardColors.removeAt(2);
      }
    }
  }
  return cardColors;
}

// Method to shuffle the cards on the draw pile
List<bool> shuffleCards(int fascistBoardCardAmount, int liberalBoardCardAmount,
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

// Method to turn to the next state after the presidential action
Future<bool> presidentialActionFinished(WidgetRef ref, int? newPresident,
    int? hitler, int? killedPlayer, int? investigatedPlayer) async {
  if (!_presidentialActionButton) {
    _presidentialActionButton = true;
    final databaseApi = ref.read(databaseApiProvider);
    final gameStateNotifier = ref.read(gameStateProvider.notifier);
    final gameState = ref.read(gameStateProvider);
    int? newGameState;
    List<int> killedPlayers = gameState.killedPlayers;
    int? newFormerChancellor = gameState.formerChancellor;
    if (killedPlayer != null) {
      killedPlayers.add(killedPlayer);
      // If Hitler is dead, the liberal wins
      if (killedPlayers.contains(hitler)) {
        newGameState = 9;
      } else if (!gameState.notHitlerConfirmed.contains(killedPlayer)) {
        gameState.notHitlerConfirmed.add(killedPlayer);
      }
    }
    // Updating the former chancellor to null if he is dead
    if (newFormerChancellor != null) {
      if (killedPlayers.contains(newFormerChancellor)) {
        newFormerChancellor = null;
      }
    }
    List<int> investigatedPlayers = gameState.investigatedPlayers;
    // Updating the investigatedPlayer
    if (investigatedPlayer != null) {
      investigatedPlayers.add(investigatedPlayer);
    }
    bool response = await databaseApi.updateDocument(
      gameStateCollectionId,
      gameStateNotifier.gameStateDocument!.$id,
      {
        'playState': newGameState ?? 0,
        'formerPresident': gameState.currentPresident,
        'formerChancellor': newFormerChancellor,
        'currentPresident': newPresident ?? _getNextPresident(
          gameState.currentPresident,
          killedPlayers,
          gameState.chancellorVoting.length,
        ),
        'killedPlayers': killedPlayers,
        'regularPresident': newPresident == null,
        'notHitlerConfirmed': gameState.notHitlerConfirmed,
        'investigatedPlayers': investigatedPlayers,
      },
    );
    _presidentialActionButton = false;
    return response;
  }
  return false;
}

// Method to check if a progress block is needed
void checkProgressBlocks(WidgetRef ref, {int? newElectionTracker}) {
  GameState gameState = ref.read(gameStateProvider);
  ProgressBlocker boardOverviewProgressBlocker = ref.read(
      boardOverviewProgressBlockerProvider.notifier);
  ProgressBlocker playersAndElectionProgressBlocker = ref.read(
      playersAndElectionProgressBlockerProvider.notifier);
  GlobalKey<CustomPageViewState> pageViewState = ref.read(customPageViewKeyProvider);
  int currentPage = pageViewState.currentState!.currentPage;
  int playState = gameState.playState;
  if (newElectionTracker != null) {
    boardOverviewProgressBlocker.updateCompleter(false);
    if (newElectionTracker > 0) {
      playersAndElectionProgressBlocker.updateCompleter(false);
    }
    return;
  }
  // Checking for the players and election page
  if ((playState == 0 || playState > 5) && currentPage == 3) {
    playersAndElectionProgressBlocker.updateCompleter(true);
  } else if (playState == 3 || playState == 4) {
    playersAndElectionProgressBlocker.updateCompleter(false);
  }
  // Checking for the board overview page
  if ((playState == 3 || playState == 2 || playState == 0 || playState == 5)
      && currentPage == 2) {
    boardOverviewProgressBlocker.updateCompleter(true);
  }
}

// Method to update the veto state
Future<bool> updateVeto(WidgetRef ref, int vetoState) async {
  final databaseApi = ref.read(databaseApiProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  final GameState gameState = ref.read(gameStateProvider);
  int newElectionTracker = gameState.electionTracker;
  int newPlayState = gameState.playState;
  int newDrawPileCardAmount = gameState.drawPileCardAmount;
  List<bool> newCardColors = List.from(gameState.cardColors);
  if (vetoState == 2) {
    newElectionTracker++;
    newDrawPileCardAmount -= 3;
    newCardColors = _checkDrawPile(newDrawPileCardAmount,
        newCardColors, true, gameState.fascistBoardCardAmount,
        gameState.liberalBoardCardAmount);
    if (newDrawPileCardAmount < 3) {
      newDrawPileCardAmount = 14 - gameState.fascistBoardCardAmount -
          gameState.liberalBoardCardAmount;
    }
  } else if (vetoState == 3) {
    newElectionTracker = 0;
  }
  if (newElectionTracker == 3) {
    newPlayState = 2;
  }
  bool response = await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'veto': vetoState,
      'electionTracker': newElectionTracker,
      'playState': newPlayState,
      'cardColors': newCardColors,
      'drawPileCardAmount': newDrawPileCardAmount,
    },
  );
  return response;
}