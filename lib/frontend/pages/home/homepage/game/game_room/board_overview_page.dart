// author: Lukas Horst

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/board_overview_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/board_functions.dart' as board_functions;
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/fascist_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/liberal_board.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/discard_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/draw_pile.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/piles/pile_functions.dart' as pile_functions;
import 'package:secret_hitler/frontend/widgets/components/text/game_room_text.dart';

class BoardOverview extends ConsumerStatefulWidget {

  final BoardOverviewBackend backend;

  const BoardOverview({super.key, required this.backend,});

  @override
  ConsumerState<BoardOverview> createState() => BoardOverviewState();
}

class BoardOverviewState extends ConsumerState<BoardOverview> with AutomaticKeepAliveClientMixin {

  late BoardOverviewBackend backend;
  bool _init = true;
  late final String _initialExplainingText;
  String currentExplainingText = '';

  // Method to get one off the playing cards
  Widget _getCard(bool isLiberal, bool isCovered, int cardIndex) {
    Widget firstWidget;
    Widget secondWidget;
    String cardName;
    if (isLiberal) {
      cardName = 'liberal';
    } else {
      cardName = 'fascist';
    }
    Widget backSide = Image.asset(
      'assets/images/policy_card_back.png',
      height: ScreenSize.screenHeight * 0.08,
      width: ScreenSize.screenWidth * 0.115,
    );
    Widget frontSide = Image.asset(
      'assets/images/policy_card_${cardName}_without_background.png',
    );
    if (isCovered) {
      firstWidget = backSide;
      secondWidget = frontSide;
    } else {
      firstWidget = frontSide;
      secondWidget = backSide;
    }
    return GestureDetector(
      onTap: () async {await backend.cardClick(cardIndex, ref);},
      child: FlipAnimation(
        key: backend.cardFlipKey[cardIndex],
        duration: const Duration(milliseconds: 600),
        firstWidget: firstWidget,
        secondWidget: secondWidget,
      ),
    );
  }

  // Method to return a playing card if active
  Widget _getPlayingCards(bool isCardActive, int cardIndex) {
    if (isCardActive) {
      return MovingAnimation(
        key: backend.cardMovingKey[cardIndex],
        duration: backend.durationValues[cardIndex],
        firstTopPosition: backend.cardTopPosition[cardIndex][0],
        firstLeftPosition: backend.cardLeftPosition[cardIndex][0],
        firstRotationPosition: backend.rotationValues[cardIndex][0],
        secondTopPosition: backend.cardTopPosition[cardIndex][1],
        secondLeftPosition: backend.cardLeftPosition[cardIndex][1],
        secondRotationPosition: backend.rotationValues[cardIndex][1],
        firstHeight: cardHeights[0],
        firstWidth: cardWidth,
        secondHeight: cardHeights[1],
        secondWidth: cardWidth,
        rotatingDuration: const Duration(milliseconds: 500),
        child: _getCard(
          backend.cardColors[cardIndex],
          true,
          cardIndex,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  // Method to put the given card amount to the draw pile inclusive the 3 cards with animation
  Future<void> updateDrawPile() async {
    // Adding the 3 playing cards
    for (int i=2; i > -1; i--) {
      // If the player isn't on the move their isn't a drawing animation
      if (backend.playState == 4 || (!backend.isOnTheMove(ref)
          && backend.playState == 3)) {
        backend.drawPileCardAmount -= 3;
        if (backend.playState == 4) {
          if (backend.discardedPresidentialCard! == i) {continue;}
        }
        await _updateAnimation('BottomCenter', 'BottomCenter', i, 1000);
      // The player is the president and has a drawing animation on playState 3 and 5
      } else if (backend.isOnTheMove(ref) || backend.playState == 5) {
        backend.drawPileCardAmount--;
        await _updateAnimation('DrawPile', 'BottomCenter', i, 1000);
      }
      backend.cardVisibility[i] = true;
    }
    if ((backend.playState == 3 && backend.isOnTheMove(ref)) || !_init) {
      for (int i=0; i < 3; i++) {
        setState(() {
          pile_functions.removeCard(backend.drawPileKey.currentState!.pileElements);
        });
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Method to empty the discard pile
  Future<void> _emptyDiscardPile(int pileCardAmount) async {
    for (int i=0; i < pileCardAmount; i++) {
      setState(() {
        pile_functions.removeCard(backend.discardPileKey.currentState!.pileElements);
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  // Method to refill the draw pile with all card off the discard pile
  Future<void> _refillDrawPile(int pileCardAmount) async {
    for (int i=0; i < pileCardAmount; i++) {
      setState(() {
        pile_functions.addCard(
          backend.drawPileKey.currentState!.pileElements,
          false,
          backend.drawPileKey.currentState!.getNextRotationKey(),
        );
      });
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  // Method to shuffle all remaining cards
  Future<void> shuffleCards() async {
    int pileCardAmount = backend.discardPileKey.currentState!.pileElements.length - 1;
    _refillDrawPile(pileCardAmount);
    await _emptyDiscardPile(pileCardAmount);
    await backend.drawPileKey.currentState?.shuffle();
  }

  // Putting the 3 drawn cards back to the draw pile
  Future<void> drawCardsBack() async {
    for (int i=2; i > -1; i--) {
      backend.drawPileCardAmount--;
      // Avoiding that you can see the updating of the animation
      if (i== 0) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      _updateAnimation('BottomCenter', 'DrawPile', i, 1000);
    }
    drawCards();
  }

  // Drawing 3 card from the draw pile
  Future<void> drawCards() async {
    for (int i=2; i > -1; i--) {
      _drawCard(i);
      await Future.delayed(const Duration(milliseconds: 150));
    }
    await Future.delayed(const Duration(milliseconds: 900));
  }

  // Draw the given card
  void _drawCard(int cardIndex) async {
    await backend.cardMovingKey[cardIndex].currentState?.animate();
    backend.cardMovingKey[cardIndex].currentState?.rotation();
  }

  // Method to discover the playing cards
  Future<void> discoverCards() async {
    int cardAmount = 0;
    for (bool visible in backend.cardVisibility) {
      if (visible) {cardAmount++;}
    }
    late List<String> cardPositions;
    if (cardAmount == 2) {
      cardPositions = ['Left', 'Right'];
    } else {
      // The cards goes from left to right (the top card is index 2)
      cardPositions = ['Right', '', 'Left'];
    }
    int count = 0;
    // Changing the move animation
    for (int i=0; i < 3; i++) {
      if (backend.cardVisibility[i]) {
        await _updateAnimation('BottomCenter',
            'BottomCenter${cardPositions[count]}', i, 750);
        count++;
      }
    }
    // Spread out the card
    for (int i=0; i < 3; i++) {
      backend.cardMovingKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (backend.isOnTheMove(ref) || backend.playCardState == -2) {
      // Flip the cards
      for (int i=0; i < 3; i++) {
        backend.cardFlipKey[i].currentState?.animate();
      }
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  // Method to cover the playing cards
  Future<void> coverCards() async {
    // Fold in the cards
    for (int i=0; i < 3; i++) {
      backend.cardMovingKey[i].currentState?.animate();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    // Flip the cards
    if ((backend.isOnTheMove(ref) || backend.playCardState == -2)
        && backend.playCardState != 0) {
      for (int i=0; i < 3; i++) {
        backend.cardFlipKey[i].currentState?.animate();
      }
    }
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // Method to update the moving animations of the given card
  Future<void> _updateAnimation(String start, String end, int cardIndex,
      int duration) async {
    Map<String, List<double>> positions = {
      'DrawPile': [topPositions[2] + (13 - backend.drawPileCardAmount) * ScreenSize.screenHeight * 0.001,
        leftPositions[0] + (13 - backend.drawPileCardAmount) * ScreenSize.screenWidth * 0.002, -10],
      'DiscardPile': [topPositions[2] + (13 - backend.discardPileCardAmount) * ScreenSize.screenHeight * 0.001,
        leftPositions[1] - (13 - backend.discardPileCardAmount) * ScreenSize.screenWidth * 0.002, 10],
      'BottomCenter': [topPositions[3], leftPositions[2], 0],
      'BottomCenterLeft': [topPositions[3] + ScreenSize.screenHeight * 0.005,
        leftPositions[2] - ScreenSize.screenWidth * 0.13, -10],
      'BottomCenterRight': [topPositions[3] + ScreenSize.screenHeight * 0.005,
        leftPositions[2] + ScreenSize.screenWidth * 0.13, 10],
      'LiberalBoard': [topPositions[1],
        liberalBoardLeftPositions[backend.liberalBoardCardAmount],
        -5 + (backend.liberalBoardCardAmount * 2.5)],
      'FascistBoard': [topPositions[0],
        fascistBoardLeftPositions[backend.fascistBoardCardAmount],
        -6 + (backend.fascistBoardCardAmount * 2.5)],
    };
    setState(() {
      backend.cardVisibility[cardIndex] = false;
    });
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      backend.cardTopPosition[cardIndex] = [positions[start]![0], positions[end]![0]];
      backend.cardLeftPosition[cardIndex] = [positions[start]![1], positions[end]![1]];
      backend.durationValues[cardIndex] = Duration(milliseconds: duration);
      if (start != 'DrawPile') {
        backend.rotationValues[cardIndex] = [0, positions[end]![2]];
      } else {
        if (end == 'FascistBoard') {
          backend.rotationValues[cardIndex] = [0,
            0.5 + (backend.fascistBoardCardAmount * 2)];
        } else if (end == 'LiberalBoard') {
          backend.rotationValues[cardIndex] = [0,
            1 + (backend.liberalBoardCardAmount * 2)];
        } else {
          backend.rotationValues[cardIndex] = [0, positions[start]![2]];
        }
      }
    });
    if (start != 'DrawPile' || end != 'BottomCenter') {
      setState(() {
        backend.cardVisibility[cardIndex] = true;
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // Method to discard a playing card
  Future<void> discard(int cardIndex) async {
    backend.discardPileCardAmount++;
    await _updateAnimation('BottomCenter',
        'DiscardPile', cardIndex, 1000);
    backend.cardMovingKey[cardIndex].currentState?.animate();
    await Future.delayed(const Duration(milliseconds: 500));
    backend.cardMovingKey[cardIndex].currentState?.rotation();
    await Future.delayed(const Duration(milliseconds: 500));
    // Replacing the animated card with a normal card
    setState(() {
      pile_functions.addCard(backend.discardPileKey.currentState!.pileElements, true, null);
      backend.cardVisibility[cardIndex] = false;
    });
  }

  // Method to play a card from the bottom center or from the draw pile
  Future<void> playCard(int cardIndex, bool normalPlay, bool cardColor) async {
    String boardColor = cardColor ? 'LiberalBoard' : 'FascistBoard';
    if (normalPlay) {
      await _updateAnimation('BottomCenter', boardColor, cardIndex, 1500);
    // If we only play the top card
    } else {
      for (int i=0; i < 3; i++) {
        pile_functions.addCard(
          backend.drawPileKey.currentState!.pileElements,
          false,
          backend.drawPileKey.currentState?.getNextRotationKey(),
        );
      }
      setState(() {});
      // Make the other animated card on the draw pile invisible
      for (int i=0; i < 2; i++) {
        backend.cardVisibility[i] = false;
      }
      setState(() {});
      backend.drawPileCardAmount += 2;
      // Updating the top card animation
      await _updateAnimation('DrawPile', boardColor, cardIndex, 1500);
      // Removing the normal card on top
      setState(() {
        pile_functions.removeCard(backend.drawPileKey.currentState!.pileElements);
      });
    }
    backend.cardMovingKey[cardIndex].currentState?.animate();
    backend.cardMovingKey[cardIndex].currentState?.size();
    await Future.delayed(const Duration(milliseconds: 1000));
    backend.cardMovingKey[cardIndex].currentState?.rotation();
    await Future.delayed(const Duration(milliseconds: 750));
    backend.cardFlipKey[cardIndex].currentState?.animate();
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      if (cardColor) {
        board_functions.addCard(
          backend.liberalBoardKey.currentState!.boardElements,
          backend.liberalBoardKey.currentState!.cardPositions,
          true,
          true,
        );
      } else {
        board_functions.addCard(
          backend.fascistBoardKey.currentState!.boardElements,
          backend.fascistBoardKey.currentState!.cardPositions,
          false,
          true,
        );
      }
      backend.cardVisibility[cardIndex] = false;
    });
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Method to check if the explaining text must be changed
  String checkExplainingText() {
    String text = '';
    final gameState = ref.read(gameStateProvider);
    int playState = gameState.playState;
    if (playState == 3) {
      if (backend.isOnTheMove(ref, rightGameState: playState)) {
        if (backend.playCardState == 1) {
          text = changeExplainingText(AppLanguage.getLanguageData()['Discard a card']);
        } else {
          text = changeExplainingText(AppLanguage.getLanguageData()['Draw 3 cards']);
        }
      } else {
        text = changeExplainingText(AppLanguage.getLanguageData()['The president discards a card']);
      }
    } else if (playState == 4) {
      if (backend.isOnTheMove(ref, rightGameState: playState)) {
        text = changeExplainingText(AppLanguage.getLanguageData()['Play a card']);
      } else {
        text = changeExplainingText(AppLanguage.getLanguageData()['The chancellor plays a card']);
      }
    } else if (playState == 5) {
      if (backend.isOnTheMove(ref, rightGameState: playState)) {
        text = changeExplainingText(AppLanguage.getLanguageData()['Examine the top 3 cards']);
      } else {
        text = changeExplainingText(AppLanguage.getLanguageData()['The president examines the top 3 cards']);
      }
    } else if (playState == 9) {
      text = changeExplainingText(AppLanguage.getLanguageData()['The liberals won']);
    } else if (playState == 10) {
      text = changeExplainingText(AppLanguage.getLanguageData()['The fascists won']);
    }
    if (text.isEmpty) {
      changeExplainingText('');
    }
    return text;
  }

  // Method to set the initial text or update the text via animation
  String changeExplainingText(String text) {
    if (!_init) {
      if (text != currentExplainingText) {
        final gameRoomTextKey = ref.read(boardOverviewGameRoomTextProvider);
        gameRoomTextKey.currentState?.updateText(text);
      }
    }
    currentExplainingText = text;
    return text;
  }

  @override
  void initState() {
    backend = widget.backend;
    final gameState = ref.read(gameStateProvider);
    backend.synchronizeValues(gameState, _init, ref);
    initialize(gameState);
    super.initState();
  }

  Future<void> initialize(GameState gameState) async {
    _initialExplainingText = checkExplainingText();
    // Removing 2 or 3 cards from the draw pile
    if ((!backend.isOnTheMove(ref) && backend.playState == 3)
        || backend.playState == 4) {
      backend.drawPileCardAmount -= (3 - (backend.playState % 3));
    }
    await Future.delayed(const Duration(milliseconds: 50));
    if (backend.playState > 1 && backend.playState < 6) {
      await updateDrawPile();
    }
    if ((!backend.isOnTheMove(ref) && backend.playState == 3)
        || backend.playState == 4) {
      await Future.delayed(const Duration(milliseconds: 500));
      await discoverCards();
    }
    _init = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final gameRoomTextKey = ref.read(boardOverviewGameRoomTextProvider);
    ref.listen(gameStateProvider, (previous, next) {
      backend.synchronizeValues(next, _init, ref);
    });
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.02),
        SizedBox(
          height: ScreenSize.screenHeight * 0.8,
          child: Stack(
            children: [
              Positioned(
                child: FascistBoard(
                  key: backend.fascistBoardKey,
                  playerAmount: backend.playerAmount,
                  cards: backend.fascistBoardCardAmount,
                  flippedCards: backend.fascistBoardFlippedCards,
                  cardFlipKeys: backend.fascistCardFlipKeys,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.175,
                child: LiberalBoard(
                  key: backend.liberalBoardKey,
                  cards: backend.liberalBoardCardAmount,
                  flippedCards: backend.liberalBoardFlippedCards,
                  cardFlipKeys: backend.liberalCardFlipKeys,
                  firstPosition: backend.electionTracker,
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.4,
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DrawPile(
                        key: backend.drawPileKey,
                        cards: backend.drawPileCardAmount,
                      ),
                      DiscardPile(
                        key: backend.discardPileKey,
                        cards: backend.discardPileCardAmount,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: ScreenSize.screenHeight * 0.56,
                child: GameRoomText(
                  key: gameRoomTextKey,
                  duration: const Duration(milliseconds: 600),
                  initialText: _initialExplainingText,
                ),
              ),
              // The 3 or 2 cards to play
              // Left card
              _getPlayingCards(backend.cardVisibility[0], 0),
              // Middle card
              _getPlayingCards(backend.cardVisibility[1], 1),
              // Right card
              _getPlayingCards(backend.cardVisibility[2], 2),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
