// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';

// Animation to make a transition from one widget to another widget
class TransitionAnimation extends StatefulWidget {

  final Duration duration;
  final Widget firstWidget;
  final Widget secondWidget;

  const TransitionAnimation({super.key, required this.duration,
    required this.firstWidget, required this.secondWidget});

  @override
  State<TransitionAnimation> createState() => TransitionAnimationState();
}

class TransitionAnimationState extends State<TransitionAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _firstTransitionAnimation;
  late Animation<double> _secondTransitionAnimation;
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
    _firstTransitionAnimation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    _firstTransitionAnimation.addListener(() {setState(() {});});
    _firstTransitionAnimation.addStatusListener((status) {
      _status = status;
    });
    _secondTransitionAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _secondTransitionAnimation.addListener(() {setState(() {});});
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
        return Stack(
          children: [
            FadeTransition(
              opacity: _firstTransitionAnimation,
              child: widget.firstWidget,
            ),
            FadeTransition(
              opacity: _secondTransitionAnimation,
              child: widget.secondWidget,
            ),
          ],
        );
      },
    );
  }
}
