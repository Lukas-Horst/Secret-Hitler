// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/components/transformedWidgets.dart';

import 'animation_controllers.dart';

// Animation to rotate a Widget
class RotationAnimation extends StatefulWidget {

  final Duration duration;
  final double firstRotationPosition;
  final double secondRotationPosition;
  final Widget animatedWidget;

  const RotationAnimation({super.key, required this.duration,
    required this.firstRotationPosition, required this.secondRotationPosition,
    required this.animatedWidget});

  @override
  State<RotationAnimation> createState() => RotationAnimationState();
}

class RotationAnimationState extends State<RotationAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
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
    _rotationAnimation = Tween(begin: widget.firstRotationPosition,
        end: widget.secondRotationPosition).animate(_controller);
    _rotationAnimation.addListener(() {setState(() {});});
    _rotationAnimation.addStatusListener((status) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AngleWidget(
          angleDegree: _rotationAnimation.value,
          angledWidget: widget.animatedWidget,
        );
      },
    );
  }
}
