// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';

// Animation to change the opacity from visible to invisible
class OpacityAnimation extends StatefulWidget {

  final Duration duration;
  final Widget child;
  final double? begin;
  final double? end;

  const OpacityAnimation({super.key, required this.duration,
    required this.child, this.begin, this.end});

  @override
  State<OpacityAnimation> createState() => OpacityAnimationState();
}

class OpacityAnimationState extends State<OpacityAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;

  Future<void> animate() async {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    await Future.delayed(widget.duration);
  }

  @override
  void initState() {
    _controller = AnimationControllers.getController(widget.duration, this);
    late double begin;
    late double end;
    if (widget.begin == null) {
      begin = 1.0;
    } else {
      begin = widget.begin!;
    }
    if (widget.end == null) {
      end = 0.0;
    } else {
      end = widget.end!;
    }
    _animation = Tween(begin: begin, end: end).animate(_controller);
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
