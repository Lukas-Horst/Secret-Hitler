// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';
import 'package:secret_hitler/frontend/widgets/components/transformedWidgets.dart';

// Animation for a flip of 2 Widgets
class FlipAnimation extends StatefulWidget {

  final Duration duration;
  final Widget firstWidget;
  final Widget secondWidget;

  const FlipAnimation({super.key, required this.duration,
    required this.firstWidget, required this.secondWidget});

  @override
  State<FlipAnimation> createState() => FlipAnimationState();
}

class FlipAnimationState extends State<FlipAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  void animate() {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    _controller = AnimationControllers.getController(widget.duration, this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {setState(() {});});
    _animation.addStatusListener((status) {
      _status = status;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(2, 1, 0.0015)
        ..rotateY(pi * _animation.value),
      child: _animation.value <= 0.5
          ? widget.firstWidget
          : MirroredWidget(child: widget.secondWidget,),
    );
  }
}
