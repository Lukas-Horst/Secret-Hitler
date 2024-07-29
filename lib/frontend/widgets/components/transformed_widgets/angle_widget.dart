// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';

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