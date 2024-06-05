// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';

class SizeAnimation extends StatefulWidget {

  final Duration duration;
  final double firstHeight;
  final double firstWidth;
  final double secondHeight;
  final double secondWidth;
  final Widget child;

  const SizeAnimation({super.key, required this.duration, required this.firstHeight,
    required this.firstWidth, required this.child,
    required this.secondHeight, required this.secondWidth});

  @override
  State<SizeAnimation> createState() => SizeAnimationState();
}

class SizeAnimationState extends State<SizeAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _widthAnimation;
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
    _heightAnimation = Tween(begin: widget.firstHeight,
        end: widget.secondHeight).animate(_controller);
    _heightAnimation.addListener(() {setState(() {});});
    _heightAnimation.addStatusListener((status) {
      _status = status;
    });

    _widthAnimation = Tween(begin: widget.firstWidth,
        end: widget.secondWidth).animate(_controller);
    _widthAnimation.addListener(() {setState(() {});});
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
        return SizedBox(
          height: _heightAnimation.value,
          width: _widthAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
