// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';

// Explaining text for the board overview page and player and election page
class GameRoomText extends StatefulWidget {

  final Duration duration;
  final String initialText;

  const GameRoomText({super.key, required this.duration,
    required this.initialText});

  @override
  State<GameRoomText> createState() => GameRoomTextState();
}

class GameRoomTextState extends State<GameRoomText> {

  final GlobalKey<OpacityAnimationState> opacityKey = GlobalKey<OpacityAnimationState>();
  bool _updateAnimation = false;
  late String _text;

  Future<void> updateText(String newText) async {
    await opacityKey.currentState?.animate();
    setState(() {
      _updateAnimation = true;
      _text = newText;
      _updateAnimation = false;
    });
    await opacityKey.currentState?.animate();
  }

  @override
  void initState() {
    _text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_updateAnimation) {
      return OpacityAnimation(
        key: opacityKey,
        duration: widget.duration,
        begin: _updateAnimation ? 0.0 : 1.0,
        end: _updateAnimation ? 1.0 : 0.0,
        child: SizedBox(
          width: ScreenSize.screenWidth * 0.96,
          child: Text(
            _text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              color: Colors.white,
              fontSize: ScreenSize.screenHeight * 0.02 +
                  ScreenSize.screenWidth * 0.02,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
