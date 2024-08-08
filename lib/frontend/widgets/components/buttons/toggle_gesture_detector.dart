// author: Lukas Horst

import 'package:flutter/material.dart';

// Gesture detector which can only be clicked once until it will be reset
class ToggleGestureDetector extends StatefulWidget {

  final Widget child;
  final Function onTap;
  final Duration? resetTimer;

  const ToggleGestureDetector({super.key, required this.child,
    required this.onTap, this.resetTimer});

  @override
  State<ToggleGestureDetector> createState() => ToggleGestureDetectorState();
}

class ToggleGestureDetectorState extends State<ToggleGestureDetector> {

  bool toggle = false;

  // Resets the toggle if we haven't a reset timer
  void reset() {
    if (toggle && widget.resetTimer == null) {
      toggle = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!toggle) {
          toggle = true;
          widget.onTap();
          if (widget.resetTimer != null) {
            await Future.delayed(widget.resetTimer!);
            toggle = false;
          }
        }
      },
      child: widget.child,
    );
  }
}

