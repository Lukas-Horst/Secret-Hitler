// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/board_overview_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/game/board_overview/boards/board_functions.dart';

class LiberalBoard extends ConsumerStatefulWidget {

  final int cards;
  final int flippedCards;
  final List<GlobalKey<FlipAnimationState>> cardFlipKeys;

  const LiberalBoard({super.key, required this.cards, required this.cardFlipKeys,
    required this.flippedCards});

  @override
  ConsumerState<LiberalBoard> createState() => LiberalBoardState();
}

class LiberalBoardState extends ConsumerState<LiberalBoard> {

  List<double> cardPositions = liberalBoardLeftPositions;
  final double _electionTrackerTopPosition = ScreenSize.screenHeight * 0.1477;
  final List<double> _electionTrackerLeftPositions = [
    ScreenSize.screenWidth * 0.3305,
    ScreenSize.screenWidth * 0.4205,
    ScreenSize.screenWidth * 0.51,
    ScreenSize.screenWidth * 0.599
  ];
  int _currentElectionTrackerPosition = 0;
  final GlobalKey<MovingAnimationState> _electionTrackerKey = GlobalKey<MovingAnimationState>();

  List<Widget> boardElements = [
    Image.asset(
    'assets/images/liberal_board.png',
    height: ScreenSize.screenHeight * 0.225,
    width: ScreenSize.screenWidth * 0.98,
    ),
  ];

  // Method to update the animated election tracker based on the next position
  Future<void> _updateElectionTrackerAnimation(int nextPosition) async {
    setState(() {
      boardElements.removeAt(2);
    });
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      boardElements.insert(2, _getAnimatedElectionTracker(nextPosition));
    });
  }

  // Method to update the static election tracker position
  Future<void> _setStaticElectionTracker(int nextPosition) async {
    setState(() {
      boardElements.removeAt(1);
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      boardElements.insert(1, _getStaticElectionTracker(nextPosition));
    });
  }

  // Method to get the animated election tracker with the next position
  Widget _getAnimatedElectionTracker(int nextPosition) {
    return MovingAnimation(
      key: _electionTrackerKey,
      duration: const Duration(milliseconds: 1000),
      firstTopPosition: _electionTrackerTopPosition,
      firstLeftPosition: _electionTrackerLeftPositions[_currentElectionTrackerPosition],
      secondTopPosition: _electionTrackerTopPosition,
      secondLeftPosition: _electionTrackerLeftPositions[nextPosition],
      child: Image.asset(
        'assets/images/election_tracker.png',
        height: ScreenSize.screenHeight * 0.035,
        width: ScreenSize.screenWidth * 0.035,
      ),
    );
  }

  Widget _getStaticElectionTracker(int position) {
    return Positioned(
      top: _electionTrackerTopPosition,
      left: _electionTrackerLeftPositions[position],
      child: Image.asset(
        'assets/images/election_tracker.png',
        height: ScreenSize.screenHeight * 0.035,
        width: ScreenSize.screenWidth * 0.035,
      ),
    );
  }

  // Method to move the election tracker one forward
  Future<void> moveElectionTrackerForward() async {
    if (_currentElectionTrackerPosition == 3) {
      return;
    }
    if (_currentElectionTrackerPosition != 0) {
      await _updateElectionTrackerAnimation(_currentElectionTrackerPosition + 1);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    _electionTrackerKey.currentState?.animate();
    _setStaticElectionTracker(_currentElectionTrackerPosition + 1);
    _currentElectionTrackerPosition++;
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  // Method to move the election tracker back to the start
  Future<void> resetElectionTracker() async {
    if (_currentElectionTrackerPosition == 0) {
      return;
    }
    await _updateElectionTrackerAnimation(0);
    await Future.delayed(const Duration(milliseconds: 100));
    _electionTrackerKey.currentState?.animate();
    _setStaticElectionTracker(0);
    _currentElectionTrackerPosition = 0;
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  void initState() {
    boardElements.add(_getStaticElectionTracker(0));
    boardElements.add(_getAnimatedElectionTracker(1));
    buildBoard(
      true,
      boardElements,
      widget.cards,
      widget.flippedCards,
      cardPositions,
      widget.cardFlipKeys,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: boardElements,
    );
  }
}
