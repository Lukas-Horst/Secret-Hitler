// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';

class MirroredWidget extends StatelessWidget {

  final Widget child;

  const MirroredWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateY(pi),
      child: child,
    );
  }
}

class AngleWidget extends StatelessWidget {

  final double angleDegree;
  final Widget child;

  const AngleWidget({super.key, required this.child,
    required this.angleDegree});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angleDegree * (pi / 180),
      child: child,
    );
  }
}

