// author: Lukas Horst

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/board_overview_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/game_room_settings_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/players_and_election_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/game_room/roles_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameRoomNavigation extends StatefulWidget {

  final int playerAmount;

  const GameRoomNavigation({super.key, required this.playerAmount});

  @override
  State<GameRoomNavigation> createState() => _GameRoomNavigationState();
}

class _GameRoomNavigationState extends State<GameRoomNavigation> {

  final _pageViewController = PageController();
  late int _playerAmount;

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void changePage(int pageNumber) {
    _pageViewController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    _playerAmount = widget.playerAmount;
    Timer(const Duration(milliseconds: 500), () {
      changePage(2);
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
                    BoardOverview(playerAmount: _playerAmount,),
                    const PlayersAndElection(),
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
