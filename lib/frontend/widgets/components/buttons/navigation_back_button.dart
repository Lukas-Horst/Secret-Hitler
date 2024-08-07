// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The back button on the navigation bar
class NavigationBackButton extends StatelessWidget {

  final Function() onPressed;

  const NavigationBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: ScreenSize.screenHeight * 0.04 +
            ScreenSize.screenWidth * 0.04,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}