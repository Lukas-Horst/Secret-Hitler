// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/activate_widget.dart';

class CustomSnackbar {

  static bool _activated = false;

  // Function to open a snackbar with a text
  static Future<void> showSnackbar(BuildContext context, String text, Color color,
      Duration duration, GlobalKey<ActivateWidgetState>? navigationBarActivateKey) async {
    if (!_activated) {
      _activated = true;
      if (navigationBarActivateKey != null) {
        // Deactivating the navigation bar if the key is given
        navigationBarActivateKey.currentState?.deactivateWidget();
      }
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
      await Future.delayed(duration);
      _activated = false;
      if (navigationBarActivateKey != null) {
        await Future.delayed(const Duration(milliseconds: 550));
        navigationBarActivateKey.currentState?.activateWidget();
      }
    }
  }

  // Function to close a snackbar if any is currently open
  static void closeSnackbar(BuildContext context) {
    _activated = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}