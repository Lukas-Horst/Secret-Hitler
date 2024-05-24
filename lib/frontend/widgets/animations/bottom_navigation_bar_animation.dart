// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/animation_controllers.dart';

// Animation to change the color of the bottom navigation bar
class CustomBottomNavigationBarAnimation extends StatefulWidget {

  final Duration duration;
  final Color firstColor;
  final Color secondColor;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomBottomNavigationBarAnimation({super.key, required this.duration,
    required this.firstColor, required this.secondColor,
    required this.children, required this.mainAxisAlignment,
    required this.crossAxisAlignment});

  @override
  State<CustomBottomNavigationBarAnimation> createState() => CustomBottomNavigationBarAnimationState();
}

class CustomBottomNavigationBarAnimationState extends State<CustomBottomNavigationBarAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _colorAnimation;
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
    _colorAnimation = ColorTween(begin: widget.firstColor, end: widget.secondColor)
        .animate(_controller);
    _colorAnimation.addStatusListener((status) {});
    _colorAnimation.addStatusListener((status) {
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
        return _AnimatedCustomBottomNavigationBar(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          color: _colorAnimation.value,
          children: widget.children,);
      },
    );
  }
}

// The bottom navigation bar widget but with the possibility to change the color
class _AnimatedCustomBottomNavigationBar extends StatefulWidget {

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Color color;

  const _AnimatedCustomBottomNavigationBar({super.key, required this.children,
    required this.mainAxisAlignment, required this.crossAxisAlignment,
    required this.color});

  @override
  State<_AnimatedCustomBottomNavigationBar> createState() => _AnimatedCustomBottomNavigationBarState();
}

class _AnimatedCustomBottomNavigationBarState extends State<_AnimatedCustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight * 0.075,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          // Children are adjustable
          ...widget.children,
        ],
      ),
    );
  }
}
