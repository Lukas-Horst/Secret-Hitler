// author: Lukas Horst

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/board_overview_backend.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/board_overview_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_settings_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/roles_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameRoomNavigation extends StatefulWidget {

  final int playerAmount;
  final List<String> playerNames;

  const GameRoomNavigation({super.key, required this.playerAmount,
    required this.playerNames});

  @override
  State<GameRoomNavigation> createState() => _GameRoomNavigationState();
}

class _GameRoomNavigationState extends State<GameRoomNavigation> {

  late GlobalKey<BoardOverviewState> boardOverviewFrontendKey;
  late BoardOverviewBackend boardOverviewBackend;
  late GlobalKey<PlayersAndElectionState> playersAndElectionFrontendKey;
  late PlayersAndElectionBackend playersAndElectionBackend;
  final _pageViewController = PageController();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void _changePage(int pageNumber) {
    _pageViewController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    boardOverviewFrontendKey = GlobalKey<BoardOverviewState>();
    boardOverviewBackend = BoardOverviewBackend(boardOverviewFrontendKey,
        widget.playerAmount, _changePage);
    playersAndElectionFrontendKey = GlobalKey<PlayersAndElectionState>();
    playersAndElectionBackend = PlayersAndElectionBackend(
        playersAndElectionFrontendKey, boardOverviewBackend, widget.playerNames);
    boardOverviewBackend.setPlayersAndElectionBackend(playersAndElectionBackend);
    Timer(const Duration(milliseconds: 500), () {
      _changePage(3);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context);
        }
      },
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
                    const Roles(),
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
