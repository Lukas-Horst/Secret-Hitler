// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/datastructure_functions.dart';
import 'package:secret_hitler/backend/pages/game/game_room/players_and_election_backend.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/toggle_gesture_detector.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text/game_room_text.dart';

class Roles extends ConsumerStatefulWidget {

  final PlayersAndElectionBackend backend;

  const Roles({super.key, required this.backend});

  @override
  ConsumerState<Roles> createState() => _RolesState();
}

class _RolesState extends ConsumerState<Roles> with AutomaticKeepAliveClientMixin {

  final GlobalKey<FlipAnimationState> _membershipFlipKey = GlobalKey<FlipAnimationState>();
  final GlobalKey<FlipAnimationState> _secretRoleFlipKey = GlobalKey<FlipAnimationState>();
  final GlobalKey<GameRoomTextState> _gameRoomTextKey = GlobalKey<GameRoomTextState>();
  final GlobalKey<ToggleGestureDetectorState> _secretRoleToggleKey = GlobalKey<ToggleGestureDetectorState>();
  final GlobalKey<ToggleGestureDetectorState> _membershipRoleToggleKey = GlobalKey<ToggleGestureDetectorState>();

  late final PlayersAndElectionBackend _backend;
  final List<double> _initialTeamMemberOpacity = [0.0, 1.0];
  final List<Widget> _cardImages = [];
  bool _gameFinish = false;

  String _getTeamMembersText() {
    String teamMembers = '';
    if (_backend.ownRole[1] == 'Fascist' || _gameFinish) {
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

  // Method to flip both cards
  void _flipCards() async {
    if (!_checkToggle() && !_gameFinish) {
      _membershipFlipKey.currentState?.animate();
      _gameRoomTextKey.currentState?.updateText(_getTeamMembersText());
      _secretRoleFlipKey.currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 4000));
      _membershipFlipKey.currentState?.animate();
      _gameRoomTextKey.currentState?.updateText('');
      _secretRoleFlipKey.currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 600));
      _resetToggle();
    }
  }

  @override
  void initState() {
    _backend = widget.backend;
    GameState gameState = ref.read(gameStateProvider);
    _cardImages.add(Image.asset('assets/images/membership_back.png',
      height: ScreenSize.screenHeight * 0.2,
      width: ScreenSize.screenWidth * 0.25,
    ));
    _cardImages.add(Image.asset(
      'assets/images/membership_${_backend.ownRole[0]}.png',
      height: ScreenSize.screenHeight * 0.2,
      width: ScreenSize.screenWidth * 0.25,
    ));
    _cardImages.add(Image.asset(
      'assets/images/role_card_back_card.png',
      height: ScreenSize.screenHeight * 0.2,
      width: ScreenSize.screenWidth * 0.25,
    ));
    _cardImages.add(Image.asset(
      'assets/images/${_backend.ownRole[1]}_Card.png',
      height: ScreenSize.screenHeight * 0.2,
      width: ScreenSize.screenWidth * 0.25,
    ));
    if (gameState.playState > 8) {
      _gameFinish = true;
      switchListElements(_initialTeamMemberOpacity, 0, 1);
      switchListElements(_cardImages, 0, 1);
      switchListElements(_cardImages, 2, 3);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen(gameStateProvider, (previous, next) async {
      if (next.playState > 8 && !_gameFinish) {
        _gameFinish = true;
        switchListElements(_initialTeamMemberOpacity, 0, 1);
        if (_checkToggle()) {
          await Future.delayed(const Duration(milliseconds: 4600));
        }
        _membershipFlipKey.currentState?.animate();
        _gameRoomTextKey.currentState?.updateText(_getTeamMembersText());
        _secretRoleFlipKey.currentState?.animate();
      }
    });
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
                _flipCards();
              },
              child: FlipAnimation(
                key: _membershipFlipKey,
                duration: const Duration(milliseconds: 600),
                firstWidget: _cardImages[0],
                secondWidget: _cardImages[1],
              ),
            ),
            ToggleGestureDetector(
              key: _secretRoleToggleKey,
              onTap: () async {
                _flipCards();
              },
              child: FlipAnimation(
                key: _secretRoleFlipKey,
                duration: const Duration(milliseconds: 600),
                firstWidget: _cardImages[2],
                secondWidget: _cardImages[3],
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenSize.screenHeight * 0.06,),
        ExplainingText(text: '${AppLanguage.getLanguageData()['Your team']}:'),
        GameRoomText(
          key: _gameRoomTextKey,
          duration: const Duration(milliseconds: 300),
          initialText: _gameFinish ? _getTeamMembersText() : '',
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
