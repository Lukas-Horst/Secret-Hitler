// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';
import 'package:secret_hitler/frontend/widgets/animations/rotation_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/size_animation.dart';

// Animation to move a widget and optionally rotate it also
class MovingAnimation extends StatefulWidget {

  final Duration duration;
  final double firstTopPosition;
  final double firstLeftPosition;
  final double secondTopPosition;
  final double secondLeftPosition;
  final Widget child;
  final double? firstRotationPosition;
  final double? secondRotationPosition;
  final double? firstHeight;
  final double? firstWidth;
  final double? secondHeight;
  final double? secondWidth;
  final Duration? sizeDuration;
  final Duration? rotatingDuration;

  const MovingAnimation({super.key, required this.duration,
    required this.firstTopPosition, required this.firstLeftPosition,
    required this.secondTopPosition, required this.secondLeftPosition,
    required this.child, this.firstRotationPosition,
    this.secondRotationPosition, this.rotatingDuration, this.firstHeight,
    this.firstWidth, this.secondHeight, this.secondWidth, this.sizeDuration});

  @override
  State<MovingAnimation> createState() => MovingAnimationState();
}

class MovingAnimationState extends State<MovingAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _leftMovingAnimation;
  late Animation<double> _topMovingAnimation;
  late GlobalKey<RotationAnimationState> _rotationKey;
  late GlobalKey<SizeAnimationState> _sizeKey;
  AnimationStatus _status = AnimationStatus.dismissed;

  late bool _withRotation;
  late bool _withSize;

  // Method to add the rotation and size animation if we have values for these animations
  Widget childWithRotationAndSize() {
    // Set the rotation or size duration to the same duration as the moving if
    // we haven't a specific one
    Duration rotatingDuration;
    Duration sizeDuration;
    late Widget rotationAnimation;
    if (widget.rotatingDuration == null) {
      rotatingDuration = widget.duration;
    } else {
      rotatingDuration = widget.rotatingDuration!;
    }
    if (widget.sizeDuration == null) {
      sizeDuration = widget.duration;
    } else {
      sizeDuration = widget.sizeDuration!;
    }

    if (_withRotation) {
      rotationAnimation = RotationAnimation(
        key: _rotationKey,
        duration: rotatingDuration,
        firstRotationPosition: widget.firstRotationPosition!,
        secondRotationPosition: widget.secondRotationPosition!,
        child: widget.child,
      );
    } else {
      rotationAnimation = widget.child;
    }

    if (_withSize) {
      return SizeAnimation(
        key: _sizeKey,
        duration: sizeDuration,
        firstHeight: widget.firstHeight!,
        firstWidth: widget.firstWidth!,
        secondHeight: widget.secondHeight ?? widget.firstHeight!,
        secondWidth: widget.secondWidth ?? widget.firstWidth!,
        child: rotationAnimation,
      );
    } else {
      return widget.child;
    }
  }

  // The moving and rotate animation
  Future<void> animate() async {
    move();
    await rotation();
  }

  // If we only want the move animation
  Future<void> move() async {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    await Future.delayed(widget.duration);
  }

  // If we only want the rotate animation
  Future<void> rotation() async {
    if (_withRotation) {
     await _rotationKey.currentState?.animate();
    }
  }

  // If we only want the size animation
  Future<void> size() async {
    if (_withSize) {
      await _sizeKey.currentState?.animate();
    }
  }

  @override
  void initState() {
    _withRotation = widget.firstRotationPosition != null
        && widget.secondRotationPosition != null;
    _withSize = widget.firstHeight != null && widget.firstWidth != null;

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
      _rotationKey = GlobalKey<RotationAnimationState>();
    }

    if (_withSize) {
      _sizeKey = GlobalKey<SizeAnimationState>();
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
          child: childWithRotationAndSize(),
        );
      },
    );
  }
}
