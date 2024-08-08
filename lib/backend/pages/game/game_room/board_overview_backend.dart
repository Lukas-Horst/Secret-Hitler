// author: Lukas Horst

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
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
    GlobalKey<MovingAnimationState>(),  // Top card
  ];

  final List<GlobalKey<FlipAnimationState>> cardFlipKey = [
    GlobalKey<FlipAnimationState>(),  // Left card
    GlobalKey<FlipAnimationState>(),  // Middle card
    GlobalKey<FlipAnimationState>(),  // Right card
    GlobalKey<FlipAnimationState>(),  // Top card
  ];

  final List<bool> cardVisibility = [
    false,  // Left card
    false,  // Middle card
    false,  // Right card
    false,  // Top card
  ];

  final List<List<double>> cardTopPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
    [0.0, 0.0],  // Top card
  ];

  final List<List<double>> cardLeftPosition = [
    [0.0, 0.0],  // Left card
    [0.0, 0.0],  // Middle card
    [0.0, 0.0],  // Right card
    [0.0, 0.0],  // Top card
  ];

  final List<List<double>> rotationValues = [
    [0.0, -10],  // Left card
    [0.0, -10],  // Middle card
    [0.0, -10],  // Right card
    [0.0, 0.0],  // Top card
  ];

  final List<Duration> durationValues = [
    const Duration(milliseconds: 1000),  // Left card
    const Duration(milliseconds: 1000),  // Middle card
    const Duration(milliseconds: 1000),  // Right card
    const Duration(milliseconds: 1000),  // Top card
  ];

  final List<bool> cardColors = [];

  int drawPileCardAmount = 14;
  late int discardPileCardAmount;
  int fascistBoardCardAmount = 0;
  late int fascistBoardFlippedCards;
  int liberalBoardCardAmount = 0;
  late int liberalBoardFlippedCards;
  late int fascistCardAmount;
  late int liberalCardAmount;
  String firstExplainingText = AppLanguage.getLanguageData()['Play a card'];
  String secondExplainingText = '';

  int playState = 0;  // The current state of the game
  List<int> playedCardIndices = [];
  late GlobalKey<BoardOverviewState> boardOverviewFrontendKey;
  late int playerAmount;
  late Function(int) changePage;
  late PlayersAndElectionBackend playersAndElectionBackend;
  bool cardClickBlocked = false;

  BoardOverviewBackend(this.boardOverviewFrontendKey, this.playerAmount,
      this.changePage) {
    discardPileCardAmount = 14 - drawPileCardAmount -
        fascistBoardCardAmount - liberalBoardCardAmount;
    fascistBoardFlippedCards = fascistBoardCardAmount;
    liberalBoardFlippedCards = liberalBoardCardAmount;
    shuffleCards();
  }

  // Setter method for the playerAndElectionBackend cause this can only set after the constructor
  void setPlayersAndElectionBackend(PlayersAndElectionBackend playersAndElectionBackend) {
    this.playersAndElectionBackend = playersAndElectionBackend;
  }

  // Method to shuffle the cards on the draw pile
  void shuffleCards() {
    fascistCardAmount = 8 - fascistBoardCardAmount;
    liberalCardAmount = 6 - liberalBoardCardAmount;
    cardColors.clear();
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
  }

  // Method for a click on the button based on the current play state
  Future<void> cardClick(int cardIndex) async {
    if (cardClickBlocked) {
      return;
    } else {
      cardClickBlocked = true;
    }

    // Drawing 3 cards from the draw pile
    if (playState == 0) {
      textTransitionKey.currentState?.animate();
      Timer(const Duration(milliseconds: 600), () {
        boardOverviewFrontendKey.currentState?.updateExplainingText(
          '',
          AppLanguage.getLanguageData()['Discard a card'],
        );
      });
      playedCardIndices = [0, 1, 2];
      await boardOverviewFrontendKey.currentState?.drawCards();
      Timer(const Duration(milliseconds: 1000), () {
        textTransitionKey.currentState?.animate();
      });
      await boardOverviewFrontendKey.currentState?.discoverCards();
      playState++;
    // Discard 1 card a the president
    } else if (playState == 1) {
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
      await boardOverviewFrontendKey.currentState?.discoverCards();
      playedCardIndices.remove(cardIndex);
      playState++;
    // Play 1 card and discard the other one
    } else if (playState == 2) {
      textTransitionKey.currentState?.animate();
      await boardOverviewFrontendKey.currentState?.coverCards();
      playedCardIndices.remove(cardIndex);
      await boardOverviewFrontendKey.currentState?.discard(playedCardIndices[0]);
      await boardOverviewFrontendKey.currentState?.playCard(cardIndex, true);
      playState = 0;
    // Playing the top card because the election tracker moved 3 times forward
    } else if (playState == 3) {
      await boardOverviewFrontendKey.currentState?.playCard(3, false);
      playState = 0;
    }
    cardClickBlocked = false;
  }
}