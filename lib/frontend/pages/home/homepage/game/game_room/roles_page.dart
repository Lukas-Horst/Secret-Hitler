// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';

class Roles extends StatefulWidget {

  final PlayersAndElectionBackend backend;

  const Roles({super.key, required this.backend});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlipAnimation(
              duration: const Duration(milliseconds: 600),
              firstWidget: Image.asset(
                'assets/images/membership_back.png',
                height: ScreenSize.screenHeight * 0.2,
                width: ScreenSize.screenWidth * 0.25,
              ),
              secondWidget: Image.asset(
                'assets/images/membership_fascist.png',
                height: ScreenSize.screenHeight * 0.2,
                width: ScreenSize.screenWidth * 0.25,
              ),
            ),
            FlipAnimation(
              duration: const Duration(milliseconds: 600),
              firstWidget: Image.asset(
                'assets/images/role_card_back_card.png',
                height: ScreenSize.screenHeight * 0.2,
                width: ScreenSize.screenWidth * 0.25,
              ),
              secondWidget: Image.asset(
                'assets/images/membership_fascist.png',
                height: ScreenSize.screenHeight * 0.2,
                width: ScreenSize.screenWidth * 0.25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
