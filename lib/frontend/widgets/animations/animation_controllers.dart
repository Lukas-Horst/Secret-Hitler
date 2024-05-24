// author: Lukas Horst

// The controller for the animation
import 'package:flutter/material.dart';

class AnimationControllers{

  static AnimationController getController(Duration duration,
      SingleTickerProviderStateMixin singleTickerProviderStateMixin) {
    return AnimationController(
      duration: duration,
      vsync: singleTickerProviderStateMixin,
    );
  }

}