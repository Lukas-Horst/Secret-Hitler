// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';

// Animation to move a widget and optionally rotate it also
class MovingAnimation extends StatefulWidget {

  final Duration duration;
  final double firstTopPosition;
  final double firstLeftPosition;
  final double secondTopPosition;
  final double secondLeftPosition;
  final Widget animatedWidget;
  final double? firstRotationPosition;
  final double? secondRotationPosition;

  const MovingAnimation({super.key, required this.duration,
    required this.firstTopPosition, required this.firstLeftPosition,
    required this.secondTopPosition, required this.secondLeftPosition,
    required this.animatedWidget, this.firstRotationPosition,
    this.secondRotationPosition});

  @override
  State<MovingAnimation> createState() => MovingAnimationState();
}

class MovingAnimationState extends State<MovingAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _leftMovingAnimation;
  late Animation<double> _topMovingAnimation;
  late Animation<double> _rotationAnimation;
  AnimationStatus _status = AnimationStatus.dismissed;

  late bool _withRotation;

  // Method to add the rotation if we have values for the rotation
  Widget childWithRotation() {
    if (_withRotation) {
      return Transform.rotate(
        angle: _rotationAnimation.value,
        child: widget.animatedWidget,
      );
    } else {
      return widget.animatedWidget;
    }
  }

  void animate() {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    _withRotation = widget.firstRotationPosition != null
        && widget.secondRotationPosition != null;

    _controller = AnimationControllers.getController(widget.duration, this);
    _leftMovingAnimation = Tween(begin: widget.firstLeftPosition,
        end: widget.secondLeftPosition).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    _leftMovingAnimation.addListener(() {setState(() {});});
    _leftMovingAnimation.addStatusListener((status) {
      _status = status;
    });

    _topMovingAnimation = Tween(begin: widget.firstTopPosition,
        end: widget.secondTopPosition).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    _topMovingAnimation.addListener(() {setState(() {});});

    if (_withRotation) {
      _rotationAnimation = Tween(begin: widget.firstRotationPosition,
          end: widget.secondRotationPosition).animate(_controller);
    }
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
        return Positioned(
          top: _topMovingAnimation.value,
          left: _leftMovingAnimation.value,
          child: childWithRotation(),
        );
      },
    );
  }
}
