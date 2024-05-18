// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Animation for a flip of 2 images
class CoinFlip extends StatefulWidget {

  final Duration duration;
  final String firstImageName;
  final String secondImageName;
  final double imageHeight;
  final double imageWidth;

  const CoinFlip({super.key, required this.duration,
    required this.firstImageName, required this.secondImageName,
    required this.imageHeight, required this.imageWidth});

  @override
  State<CoinFlip> createState() => CoinFlipState();
}

class CoinFlipState extends State<CoinFlip> with SingleTickerProviderStateMixin {

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
    _controller = CoinFlipController.controller(widget.duration, this);
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller);
    _animation.addListener(() {setState(() {});});
    _animation.addStatusListener((status) {
      _status = status;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(2, 1, 0.0015)
        ..rotateY(pi * _animation.value),
      child: _animation.value <= 0.5
          ? Image.asset(
            'assets/images/${widget.firstImageName}.png',
            height: widget.imageHeight,
            width: widget.imageWidth,)
          : Image.asset(
            'assets/images/${widget.secondImageName}.png',
            height: widget.imageHeight,
            width: widget.imageWidth,),

    );
  }
}

// The controller for the animation
class CoinFlipController{

  static AnimationController controller(Duration duration,
      SingleTickerProviderStateMixin singleTickerProviderStateMixin) {
    return AnimationController(
      duration: duration,
      vsync: singleTickerProviderStateMixin,
    );
  }

}
