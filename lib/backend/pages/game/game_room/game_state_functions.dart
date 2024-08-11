// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';

// Function to get the next player who is alive for the next regular president
int getNextPresident(int currentNextPresident, List<int> killedPlayers) {
  currentNextPresident++;
  while (true) {
    if (killedPlayers.contains(currentNextPresident)) {
      currentNextPresident++;
    } else {
      return currentNextPresident;
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
  if (votingFinished) {
    newState = _countVoting(chancellorVoting);
  }
  await databaseApi.updateDocument(
    gameStateCollectionId,
    gameStateNotifier.gameStateDocument!.$id,
    {
      'playState': newState,
      'chancellorVoting': chancellorVoting,
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
int _countVoting(List<int> chancellorVoting) {
  int neededVotes = floorDivision(chancellorVoting.length, 2) + 1;
  for (int voting in chancellorVoting) {
    if (voting == 2) {
      neededVotes--;
    }
    if (neededVotes == 0) {
      return 2;
    }
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