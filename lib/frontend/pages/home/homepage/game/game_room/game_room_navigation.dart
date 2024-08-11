// author: Lukas Horst

import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/convertAppwriteData.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/board_overview_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_settings_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/roles_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameRoomNavigation extends ConsumerStatefulWidget {

  final Document gameStateDocument;

  const GameRoomNavigation({super.key, required this.gameStateDocument,});

  @override
  ConsumerState<GameRoomNavigation> createState() => _GameRoomNavigationState();
}

class _GameRoomNavigationState extends ConsumerState<GameRoomNavigation> {

  late GlobalKey<BoardOverviewState> boardOverviewFrontendKey;
  late BoardOverviewBackend boardOverviewBackend;
  late GlobalKey<PlayersAndElectionState> playersAndElectionFrontendKey;
  late PlayersAndElectionBackend playersAndElectionBackend;
  final _pageViewController = PageController();

  void _changePage(int pageNumber) {
    _pageViewController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    final List<String> playerNames = convertDynamicToStringList(
        widget.gameStateDocument.data['playerNames']);
    final List<String> playerOrder = convertDynamicToStringList(
        widget.gameStateDocument.data['playerOrder']);
    final List<String> playerRoles = convertDynamicToStringList(
        widget.gameStateDocument.data['playerRoles']);
    final userState = ref.read(userStateProvider);
    final String id = userState.user!.$id;
    boardOverviewFrontendKey = GlobalKey<BoardOverviewState>();
    boardOverviewBackend = BoardOverviewBackend(
      boardOverviewFrontendKey,
      playerOrder.length,
      _changePage,
    );
    playersAndElectionFrontendKey = GlobalKey<PlayersAndElectionState>();
    playersAndElectionBackend = PlayersAndElectionBackend(
      playersAndElectionFrontendKey,
      boardOverviewBackend,
      playerNames,
      playerOrder,
      id,
      playerRoles,
    );
    boardOverviewBackend.setPlayersAndElectionBackend(playersAndElectionBackend);
    final gameStatNotifier = ref.read(gameStateProvider.notifier);
    gameStatNotifier.subscribeGameState(widget.gameStateDocument.$id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameRoomStateNotifier = ref.watch(gameRoomStateProvider.notifier);
    gameRoomStateNotifier.resetGameRoom();
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {},
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              SizedBox(
                height: ScreenSize.screenHeight * 0.88,
                child: PageView(
                  controller: _pageViewController,
                  children: [
                    const GameRoomSettings(),
                    Roles(
                      backend: playersAndElectionBackend,
                    ),
                    BoardOverview(
                      key: boardOverviewFrontendKey,
                      backend: boardOverviewBackend,
                    ),
                    PlayersAndElection(
                      key: playersAndElectionFrontendKey,
                      backend: playersAndElectionBackend,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              SmoothPageIndicator(
                controller: _pageViewController,
                count: 4,
                effect: const WormEffect(
                  paintStyle: PaintingStyle.stroke,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
