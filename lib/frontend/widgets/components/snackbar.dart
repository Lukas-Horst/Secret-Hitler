// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Function to open a snackbar with a text
void showSnackbar(BuildContext context, String text, Color color, Duration duration) {
  // If a snackbar is currently open, it will close and the new one will open
  closeSnackbar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          color: Colors.white,
          fontSize: ScreenSize.screenHeight * 0.0175 +
              ScreenSize.screenWidth * 0.0175,
        ),
      ),
      backgroundColor: color,
      duration: duration,
    ),
  );
}

// Function to close a snackbar if any is currently open
void closeSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}