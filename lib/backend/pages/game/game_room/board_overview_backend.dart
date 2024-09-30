// author: Lukas Horst

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
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
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/page_view.dart';

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
  String firstExplainingText = '';
  String secondExplainingText = '';
  int? discardedPresidentialCard;
  int? playedCard;
  late int playState;
  int electionTracker = 0;
  int veto = 0;
  bool _vetoShuffle = false;

  int playCardState = -1;  // The current state of the played cards
  List<int> playedCardIndices = [];
  late GlobalKey<BoardOverviewState> boardOverviewFrontendKey;
  late int playerAmount;
  late PlayersAndElectionBackend playersAndElectionBackend;
  bool cardClickBlocked = false;
  GameState? _oldGameState;

  BoardOverviewBackend(this.boardOverviewFrontendKey, this.playerAmount);

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
      boardOverviewFrontendKey.currentState?.changeExplainingText('');
      await boardOverviewFrontendKey.currentState?.drawCards();
      boardOverviewFrontendKey.currentState?.changeExplainingText(AppLanguage.getLanguageData()['Discard a card']);
      await boardOverviewFrontendKey.currentState?.discoverCards();
      playCardState++;
    // Discard 1 card as the president
    } else if (playCardState == 1) {
      playCardState = -2;
      await discardCard(ref, cardIndex);
    // Play 1 card and discard the other one
    } else if (playCardState == 2) {
      playCardState = -2;
      if (!await playCard(ref, cardIndex, true)) {
        playCardState = 2;
      }
    // Examine the top 3 cards
    } else if (playCardState == 4) {
      if (await presidentialActionFinished(ref, null, null, null, null)) {
        playCardState = -2;
        boardOverviewFrontendKey.currentState?.changeExplainingText('');
        await boardOverviewFrontendKey.currentState?.drawCards();
        await boardOverviewFrontendKey.currentState?.discoverCards();
        await Future.delayed(const Duration(seconds: 3));
        await boardOverviewFrontendKey.currentState?.coverCards();
        await boardOverviewFrontendKey.currentState?.drawCardsBack();
      }
    }
    cardClickBlocked = false;
  }

  // Method to check if the player is currently on the move
  bool isOnTheMove(WidgetRef ref, {int? rightGameState}) {
    final gameState = ref.read(gameStateProvider);
    int playState = rightGameState ?? this.playState;
    // The president is on the move
    if (playState != 4) {
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
    if (init) {
      veto = gameState.veto;
      _oldGameState = gameState.copy();
    } else if (gameState.isEqual(_oldGameState!) && !init) {
      return;
    } else if (!init) {
      _oldGameState = gameState.copy();
    }
    if (boardOverviewFrontendKey.currentState!.currentExplainingText.isNotEmpty
        && (gameState.playState < 2 || gameState.playState > 5)) {
      boardOverviewFrontendKey.currentState?.changeExplainingText('');
    }
    final pageViewKey = ref.read(customPageViewKeyProvider);
    ProgressBlocker boardOverviewProgressBlocker = ref.read(
        boardOverviewProgressBlockerProvider.notifier);
    bool cardPlayed = false;
    bool shuffle = false;
    // A fascist card was played
    if (fascistBoardCardAmount != gameState.fascistBoardCardAmount && !init) {
      playedCard = gameState.playedCard;
      await _playCardAnimation(false, init, ref);
      cardPlayed = true;
    }
    // A liberal card was played
    if (liberalBoardCardAmount != gameState.liberalBoardCardAmount && !init) {
      playedCard = gameState.playedCard;
      await _playCardAnimation(true, init, ref);
      cardPlayed = true;
    }
    discardedPresidentialCard = gameState.discardedPresidentialCard;
    fascistBoardCardAmount = gameState.fascistBoardCardAmount;
    liberalBoardCardAmount = gameState.liberalBoardCardAmount;
    fascistBoardFlippedCards = fascistBoardCardAmount;
    liberalBoardFlippedCards = liberalBoardCardAmount;
    cardColors = gameState.cardColors;
    drawPileCardAmount = gameState.drawPileCardAmount;
    discardPileCardAmount = 14 - drawPileCardAmount
        - fascistBoardCardAmount - liberalBoardCardAmount;
    // Checking if a shuffle is necessary
    if (!init) {
      if (playState == 4 || playState == 2) {
        shuffle = discardPileCardAmount == 0;
      }
    }
    playState = gameState.playState;
    if (fascistBoardCardAmount != 6 && liberalBoardCardAmount != 5) {
      await _checkElectionTracker(
        init, gameState, boardOverviewProgressBlocker, pageViewKey,
      );
      if (playState != 4 || playCardState == 2) {
        await _checkVeto(ref, gameState, shuffle);
      }
    }
    // Checking for a change of the play state and the play card state
    if (playState == 3 && (playCardState < 0 || playCardState > 1)) {
      playCardState = 0;
      if (!init) {
        await boardOverviewFrontendKey.currentState?.updateDrawPile();
        await boardOverviewProgressBlocker.waitForUpdate();
        boardOverviewFrontendKey.currentState?.checkExplainingText();
        if (!isOnTheMove(ref)) {
          await boardOverviewFrontendKey.currentState?.discoverCards();
        }
      }
    } else if (playState == 4 && playCardState != 2) {
      // Activate the discard animation for all players
      if (!init) {
        boardOverviewFrontendKey.currentState?.changeExplainingText('');
        await boardOverviewFrontendKey.currentState?.coverCards();
        playCardState = 1;
        await boardOverviewFrontendKey.currentState?.discard(discardedPresidentialCard!);
        boardOverviewFrontendKey.currentState?.checkExplainingText();
        if (isOnTheMove(ref)) {
          boardOverviewFrontendKey.currentState?.vetoPressed = false;
          await boardOverviewFrontendKey.currentState?.vetoActivateKey.currentState?.activateWidget();
          boardOverviewFrontendKey.currentState?.vetoOpacityKey.currentState?.animate();
        }
        await boardOverviewFrontendKey.currentState?.discoverCards();
      }
      playCardState = 2;
      if (init) {
        drawPileCardAmount--;
        discardPileCardAmount++;
      }
    } else if (playState == 2 && playCardState != 3) {
      playCardState = 3;
      await boardOverviewFrontendKey.currentState?.updateDrawPile();
      await boardOverviewProgressBlocker.waitForUpdate();
      if (isOnTheMove(ref)) {
        await playCard(ref, 2, false);
      }
    } else if (playState == 5 && playCardState != 4) {
      if (isOnTheMove(ref) && !init) {
        await boardOverviewFrontendKey.currentState?.updateDrawPile();
      }
      await boardOverviewProgressBlocker.waitForUpdate();
      boardOverviewFrontendKey.currentState?.checkExplainingText();
      playCardState = 4;
    }
    if (fascistBoardCardAmount != 6 && liberalBoardCardAmount != 5
        && cardPlayed && !_vetoShuffle) {
      if (shuffle) {
        await boardOverviewFrontendKey.currentState?.shuffleCards();
      }
    }
    if (playState == 4 && playCardState != 2) {
      await _checkVeto(ref, gameState, shuffle);
    }
    if (cardPlayed) {
      if (gameState.playState < 9 && gameState.playState != 5) {
        await pageViewKey.currentState?.changeScrollPhysics(
          true,
          null,
          3,
        );
      }
    }
    if (gameState.playState > 8) {
      await pageViewKey.currentState?.changeScrollPhysics(
        true,
        null,
        null,
      );
      boardOverviewFrontendKey.currentState?.checkExplainingText();
    }
  }

  // Method to check if the veto state changed
  Future<void> _checkVeto(WidgetRef ref, GameState gameState, bool shuffle) async {
    if (veto != gameState.veto) {
      veto = gameState.veto;
      if (veto == 0) {
        cardClickBlocked = false;
        _vetoShuffle = false;
      } else if (veto == 1) {
        boardOverviewFrontendKey.currentState?.checkExplainingText();
        if (isPresident(gameState)) {
          for (int i=0; i < 2; i++) {
            boardOverviewFrontendKey.currentState?.ballotCardToggleKey[i]
                .currentState?.toggle = false;
          }
          for (int i=0; i < 3; i++) {
            boardOverviewFrontendKey.currentState?.playingCardOpacityKey[i]
                .currentState?.animate();
          }
        }
      } else if (veto == 2) {
        if (!isPresident(gameState)) {
          await boardOverviewFrontendKey.currentState?.checkExplainingText();
        } else {
          boardOverviewFrontendKey.currentState?.checkExplainingText();
          await Future.delayed(const Duration(milliseconds: 4600));
          for (int i=0; i < 3; i++) {
            boardOverviewFrontendKey.currentState?.playingCardOpacityKey[i]
                .currentState?.animate();
          }
          await Future.delayed(const Duration(milliseconds: 600));
        }
        // Discarding both cards
        playedCardIndices = [0, 1, 2];
        playedCardIndices.remove(discardedPresidentialCard);
        await boardOverviewFrontendKey.currentState?.coverCards();
        await Future.delayed(const Duration(milliseconds: 200));
        boardOverviewFrontendKey.currentState?.discard(playedCardIndices[0]);
        await Future.delayed(const Duration(milliseconds: 150));
        await boardOverviewFrontendKey.currentState?.discard(playedCardIndices[1]);
        if (shuffle) {
          _vetoShuffle = true;
          await boardOverviewFrontendKey.currentState?.shuffleCards();
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } else if (veto == 3) {
        if (isOnTheMove(ref)) {
          await boardOverviewFrontendKey.currentState?.checkExplainingText();
          await boardOverviewFrontendKey.currentState?.flipCards();
        } else {
          boardOverviewFrontendKey.currentState?.checkExplainingText();
          if (isPresident(gameState)) {
            await Future.delayed(const Duration(milliseconds: 4600));
            for (int i=0; i < 3; i++) {
              boardOverviewFrontendKey.currentState?.playingCardOpacityKey[i]
                  .currentState?.animate();
            }
          }
        }
        cardClickBlocked = false;
      }
    }
  }

  // Method to check if the election tracker changed
  Future<void> _checkElectionTracker(bool init, GameState gameState,
      ProgressBlocker boardOverviewProgressBlocker,
      GlobalKey<CustomPageViewState> pageViewKey) async {
    // The election tracker moved
    if (electionTracker != gameState.electionTracker) {
      if (!init && (playState == 0 || playState == 3)) {
        await boardOverviewProgressBlocker.waitForUpdate();
        bool changePageAgain = (gameState.electionTracker != 3)
            && (gameState.electionTracker != 0);
        pageViewKey.currentState?.changeScrollPhysics(
          gameState.electionTracker != 0 ? false : true,
          changePageAgain ? const Duration(seconds:  2) : null,
          changePageAgain ? 3 : null,
        );
      }
      // Resetting the election tracker
      if (electionTracker > gameState.electionTracker && !init) {
        await liberalBoardKey.currentState?.resetElectionTracker();
        // Moving the election tracker forward
      } else if (!init) {
        liberalBoardKey.currentState?.moveElectionTrackerForward();
      }
      electionTracker = gameState.electionTracker;
    }
  }

  // Method to start the animation for playing a card
  Future<void> _playCardAnimation(bool cardColor, bool init, WidgetRef ref) async {
    final pageViewKey = ref.read(customPageViewKeyProvider);
    bool normalPlay = playCardState != 3;
    await pageViewKey.currentState?.changePage(2);
    pageViewKey.currentState?.changeScrollPhysics(false, null, null);
    if (!init && normalPlay) {
      playedCardIndices = [0, 1, 2];
      playedCardIndices.remove(discardedPresidentialCard);
      playedCardIndices.remove(playedCard!);
      await boardOverviewFrontendKey.currentState?.coverCards();
      if (playCardState == -2) {
        playCardState = 2;
      }
      await boardOverviewFrontendKey.currentState?.discard(playedCardIndices[0]);
    }
    await boardOverviewFrontendKey.currentState?.playCard(
      playedCard!,
      normalPlay,
      cardColor,
    );
  }

  // Method to check if the player is the current president
  bool isPresident(GameState gameState) {
    return playersAndElectionBackend.ownPlayerIndex == gameState.currentPresident;
  }
}