// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';

class MirroredWidget extends StatelessWidget {

  final Widget mirroredWidget;

  const MirroredWidget({super.key, required this.mirroredWidget});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateY(pi),
      child: mirroredWidget,
    );
  }
}

class AngleWidget extends StatelessWidget {

  final Widget angledWidget;
  final double angleDegree;

  const AngleWidget({super.key, required this.angledWidget,
    required this.angleDegree});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDegree * (pi / 180),
      child: angledWidget,
    );
  }
}

