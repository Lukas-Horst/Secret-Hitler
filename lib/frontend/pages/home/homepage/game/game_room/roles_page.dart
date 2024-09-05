// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/toggle_gesture_detector.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';

class Roles extends StatefulWidget {

  final PlayersAndElectionBackend backend;

  const Roles({super.key, required this.backend});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> with AutomaticKeepAliveClientMixin {

  final GlobalKey<FlipAnimationState> _membershipFlipKey = GlobalKey<FlipAnimationState>();
  final GlobalKey<FlipAnimationState> _secretRoleFlipKey = GlobalKey<FlipAnimationState>();
  final GlobalKey<OpacityAnimationState> _teamMembersOpacityKey = GlobalKey<OpacityAnimationState>();
  final GlobalKey<ToggleGestureDetectorState> _secretRoleToggleKey = GlobalKey<ToggleGestureDetectorState>();
  final GlobalKey<ToggleGestureDetectorState> _membershipRoleToggleKey = GlobalKey<ToggleGestureDetectorState>();

  late final PlayersAndElectionBackend _backend;

  String _getTeamMembersText() {
    String teamMembers = '';
    if (_backend.ownRole[1] == 'Fascist') {
      for (String teamMember in _backend.teamMembers) {
        teamMembers += '• $teamMember\n';
      }
    } else {
      return '${AppLanguage.getLanguageData()['You don\'t know any other team member']}.';
    }
    return teamMembers;
  }

  // Method to check if any of the two gesture detection is toggled
  bool _checkToggle() {
    return _membershipRoleToggleKey.currentState!.toggle
        || _secretRoleToggleKey.currentState!.toggle;
  }

  // Method to reset both toggles
  void _resetToggle() {
    _membershipRoleToggleKey.currentState!.toggle = false;
    _secretRoleToggleKey.currentState!.toggle = false;
  }

  @override
  void initState() {
    _backend = widget.backend;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(height: ScreenSize.screenHeight * 0.03,),
        ExplainingText(text: '${AppLanguage.getLanguageData()['Your role']}:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleGestureDetector(
              key: _membershipRoleToggleKey,
              onTap: () async {
                if (!_checkToggle()) {
                  _membershipFlipKey.currentState?.animate();
                  _teamMembersOpacityKey.currentState?.animate();
                  _secretRoleFlipKey.currentState?.animate();
                  await Future.delayed(const Duration(milliseconds: 4000));
                  _membershipFlipKey.currentState?.animate();
                  _teamMembersOpacityKey.currentState?.animate();
                  _secretRoleFlipKey.currentState?.animate();
                  await Future.delayed(const Duration(milliseconds: 600));
                  _resetToggle();
                }
              },
              child: FlipAnimation(
                key: _membershipFlipKey,
                duration: const Duration(milliseconds: 600),
                firstWidget: Image.asset(
                  'assets/images/membership_back.png',
                  height: ScreenSize.screenHeight * 0.2,
                  width: ScreenSize.screenWidth * 0.25,
                ),
                secondWidget: Image.asset(
                  'assets/images/membership_${_backend.ownRole[0]}.png',
                  height: ScreenSize.screenHeight * 0.2,
                  width: ScreenSize.screenWidth * 0.25,
                ),
              ),
            ),
            ToggleGestureDetector(
              key: _secretRoleToggleKey,
              onTap: () async {
                if (!_checkToggle()) {
                  _membershipFlipKey.currentState?.animate();
                  _teamMembersOpacityKey.currentState?.animate();
                  _secretRoleFlipKey.currentState?.animate();
                  await Future.delayed(const Duration(milliseconds: 4000));
                  _membershipFlipKey.currentState?.animate();
                  _teamMembersOpacityKey.currentState?.animate();
                  _secretRoleFlipKey.currentState?.animate();
                  await Future.delayed(const Duration(milliseconds: 600));
                  _resetToggle();
                }
              },
              child: FlipAnimation(
                key: _secretRoleFlipKey,
                duration: const Duration(milliseconds: 600),
                firstWidget: Image.asset(
                  'assets/images/role_card_back_card.png',
                  height: ScreenSize.screenHeight * 0.2,
                  width: ScreenSize.screenWidth * 0.25,
                ),
                secondWidget: Image.asset(
                  'assets/images/${_backend.ownRole[1]}_Card.png',
                  height: ScreenSize.screenHeight * 0.2,
                  width: ScreenSize.screenWidth * 0.25,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenSize.screenHeight * 0.06,),
        ExplainingText(text: '${AppLanguage.getLanguageData()['Your team']}:'),
        OpacityAnimation(
          key: _teamMembersOpacityKey,
          begin: 0,
          end: 1,
          duration: const Duration(milliseconds: 600),
          child: ExplainingText(text: _getTeamMembersText()),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
