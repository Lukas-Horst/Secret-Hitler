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
