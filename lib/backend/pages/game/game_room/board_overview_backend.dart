// author: Lukas Horst

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/board_overview_page.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/transition_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/fascist_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/liberal_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/discard_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/draw_pile.dart';

// Backend class for the board overview page
class BoardOverviewBackend{
  final List<GlobalKey<FlipAnimationState>> liberalCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
  ];

  final List<GlobalKey<FlipAnimationState>> fascistCardFlipKeys = [
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
    GlobalKey<FlipAnimationState>(),
  ];

  final GlobalKey<DrawPileState> drawPileKey = GlobalKey<DrawPileState>();
  final GlobalKey<DiscardPileState> discardPileKey = GlobalKey<DiscardPileState>();
  final GlobalKey<FascistBoardState> fascistBoardKey = GlobalKey<FascistBoardState>();
  final GlobalKey<LiberalBoardState> liberalBoardKey = GlobalKey<LiberalBoardState>();
  final GlobalKey<TransitionAnimationState> textTransitionKey = GlobalKey<TransitionAnimationState>();

  final List<GlobalKey<MovingAnimationState>> cardMovingKey = [
    GlobalKey<MovingAnimationState>(),  // Left card
    GlobalKey<MovingAnimationState>(),  // Middle card
    GlobalKey<MovingAnimationState>(),  // Right card
  ];

  final List<GlobalKey<FlipAnimationState>> cardFlipKey = [
    GlobalKey<FlipAnimationState>(),  // Left card
    GlobalKey<FlipAnimationState>(),  // Middle card
    GlobalKey<FlipAnimationState>(),  // Right card
  ];

  final List<bool> cardVisibility = [
    false,  // Left card
    false,  // Middle card
    false,  // Right card
  ];

  final List<List<double>> cardTopPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
  ];

  final List<List<double>> cardLeftPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
  ];

  final List<List<double>> rotationValues = [
    [0.0, -10],  // Left card
    [0.0, -10],  // Middle card
    [0.0, -10],  // Right card
  ];

  final List<Duration> durationValues = [
    const Duration(milliseconds: 1000),  // Left card
    const Duration(milliseconds: 1000),  // Middle card
    const Duration(milliseconds: 1000),  // Right card
    const Duration(milliseconds: 1000),  // Top card
  ];

  List<bool> cardColors = [];

  int drawPileCardAmount = 14;
  late int discardPileCardAmount;
  int fascistBoardCardAmount = 0;
  late int fascistBoardFlippedCards;
  int liberalBoardCardAmount = 0;
  late int liberalBoardFlippedCards;
  String firstExplainingText = AppLanguage.getLanguageData()['Play a card'];
  String secondExplainingText = '';
  int? discardedPresidentialCard;
  late int playState;
  int electionTracker = 0;

  int playCardState = -1;  // The current state of the played cards
  List<int> playedCardIndices = [];
  late GlobalKey<BoardOverviewState> boardOverviewFrontendKey;
  late int playerAmount;
  late Function(int) changePage;
  late PlayersAndElectionBackend playersAndElectionBackend;
  bool cardClickBlocked = false;

  BoardOverviewBackend(this.boardOverviewFrontendKey, this.playerAmount,
      this.changePage);

  // Setter method for the playerAndElectionBackend cause this can only set after the constructor
  void setPlayersAndElectionBackend(PlayersAndElectionBackend playersAndElectionBackend) {
    this.playersAndElectionBackend = playersAndElectionBackend;
  }

  // Method for a click on the button based on the current play state
  Future<void> cardClick(int cardIndex, WidgetRef ref) async {
    if (cardClickBlocked || !isOnTheMove(ref)) {
      return;
    } else {
      cardClickBlocked = true;
    }
    // Drawing 3 cards from the draw pile
    if (playCardState == 0) {
      textTransitionKey.currentState?.animate();
      Timer(const Duration(milliseconds: 600), () {
        boardOverviewFrontendKey.currentState?.updateExplainingText(
          '',
          AppLanguage.getLanguageData()['Discard a card'],
        );
      });
      await boardOverviewFrontendKey.currentState?.drawCards();
      Timer(const Duration(milliseconds: 1000), () {
        textTransitionKey.currentState?.animate();
      });
      await boardOverviewFrontendKey.currentState?.discoverCards();
      playCardState++;
    // Discard 1 card as the president
    } else if (playCardState == 1) {
      textTransitionKey.currentState?.animate();
      Timer(const Duration(milliseconds: 600), () {
        boardOverviewFrontendKey.currentState?.updateExplainingText(
          '',
          AppLanguage.getLanguageData()['Play a card'],
        );
      });
      await boardOverviewFrontendKey.currentState?.coverCards();
      await boardOverviewFrontendKey.currentState?.discard(cardIndex);
      Timer(const Duration(milliseconds: 1000), () {
        textTransitionKey.currentState?.animate();
      });
      await discardCard(ref, cardIndex);
    // Play 1 card and discard the other one
    } else if (playCardState == 2) {
      playedCardIndices = [0, 1, 2];
      playedCardIndices.remove(discardedPresidentialCard);
      playedCardIndices.remove(cardIndex);
      textTransitionKey.currentState?.animate();
      await boardOverviewFrontendKey.currentState?.coverCards();
      await boardOverviewFrontendKey.currentState?.discard(playedCardIndices[0]);
      await playCard(ref, cardIndex, true);
    // Playing the top card because the election tracker moved 3 times forward
    } else if (playCardState == 3) {
      await playCard(ref, 2, false);
    }
    cardClickBlocked = false;
  }

  // Method to check if the player is currently on the move
  bool isOnTheMove(WidgetRef ref) {
    final gameState = ref.read(gameStateProvider);
    return false;
    // return false;
    // The president is on the move
    if (playState == 3 || playState == 2) {
      return gameState.currentPresident == playersAndElectionBackend.ownPlayerIndex;
    // The chancellor is on the move
    } else if (playState == 4) {
      return gameState.currentChancellor == playersAndElectionBackend.ownPlayerIndex;
    } else {
      return false;
    }
  }

  // Method to synchronize all values with the server
  void synchronizeValues(GameState gameState, bool init, WidgetRef ref) async {
    bool cardPlayed = false;
    bool shuffle = false;

    // The election tracker moved
    if (electionTracker != gameState.electionTracker) {
      // Resetting the election tracker
      if (electionTracker > gameState.electionTracker && !init) {
        await liberalBoardKey.currentState?.resetElectionTracker();
      // Moving the election tracker forward
      } else if (!init) {
        await liberalBoardKey.currentState?.moveElectionTrackerForward();
      }
      electionTracker = gameState.electionTracker;
    }
    // A fascist card was played
    if (fascistBoardCardAmount != gameState.fascistBoardCardAmount && !init) {
      await _playCardAnimation(false, gameState, init, ref);
      cardPlayed = true;
    }
    // A liberal card was played
    if (liberalBoardCardAmount != gameState.liberalBoardCardAmount && !init) {
      await _playCardAnimation(true, gameState, init, ref);
      cardPlayed = true;
    }
    // Checking if a shuffle is necessary
    if (!init) {
      if (playState == 4 || playState == 2) {
        shuffle = drawPileCardAmount < gameState.drawPileCardAmount;
      }
    }
    playState = gameState.playState;
    discardedPresidentialCard = gameState.discardedPresidentialCard;
    fascistBoardCardAmount = gameState.fascistBoardCardAmount;
    liberalBoardCardAmount = gameState.liberalBoardCardAmount;
    fascistBoardFlippedCards = fascistBoardCardAmount;
    liberalBoardFlippedCards = liberalBoardCardAmount;
    cardColors = gameState.cardColors;
    drawPileCardAmount = gameState.drawPileCardAmount;
    discardPileCardAmount = 14 - drawPileCardAmount
        - fascistBoardCardAmount - liberalBoardCardAmount;
    // Checking for a change of the play state and the play card state
    if (playState == 3 && (playCardState < 0 || playCardState != 1)) {
      playCardState = 0;
      if (!isOnTheMove(ref) && !init) {
        await boardOverviewFrontendKey.currentState?.updateDrawPile();
        await boardOverviewFrontendKey.currentState?.discoverCards();
      }
    } else if (playState == 4 && playCardState < 2) {
      // Activate the discard animation for all players who wasn't on the move
      if (playCardState != 1 && !init) {
        await boardOverviewFrontendKey.currentState?.coverCards();
        await boardOverviewFrontendKey.currentState?.discard(discardedPresidentialCard!);
      }
      if (!init) {
        await boardOverviewFrontendKey.currentState?.discoverCards();
      }
      playCardState = 2;
      if (init) {
        discardPileCardAmount++;
      }
    } else if (playState == 2 && playCardState < 3) {
      playCardState = 3;
    }
    if (fascistBoardCardAmount != 6 && liberalBoardCardAmount != 5 && cardPlayed) {
      if (shuffle) {
        await boardOverviewFrontendKey.currentState?.shuffleCards();
      }
    }
  }

  // Method to get one of the two played card which fits with the color
  int _getPlayedCardIndex(GameState gameState, bool cardColor, bool normalPlay) {
    if (!normalPlay) {return 2;}
    for (int i=0; i < 3; i++) {
      if (cardVisibility[i]) {
        return i;
      }
    }
    return 0;
  }

  // Method to start the animation for playing a card
  Future<void> _playCardAnimation(bool cardColor, GameState gameState,
      bool init, WidgetRef ref) async {
    bool normalPlay = playCardState != 3;
    int playedCardIndex = _getPlayedCardIndex(gameState, false, normalPlay);
    if (!init && !isOnTheMove(ref) && normalPlay) {
      playedCardIndices = [0, 1, 2];
      playedCardIndices.remove(discardedPresidentialCard);
      playedCardIndices.remove(playedCardIndex);
      await boardOverviewFrontendKey.currentState?.coverCards();
      await boardOverviewFrontendKey.currentState?.discard(playedCardIndices[0]);
    }
    await boardOverviewFrontendKey.currentState?.playCard(
      playedCardIndex,
      normalPlay,
      cardColor,
    );
  }
}