// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class CustomSnackbar {

  static bool _activated = false;

  // Function to open a snackbar with a text
  static Future<void> showSnackbar(String text, Color color,
      Duration duration) async {
    if (!_activated) {
      _activated = true;
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        duration: duration,
        titleText: const SizedBox(),
        messageText: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'EskapadeFrakturW04BlackFamily',
            color: Colors.white,
            fontSize: ScreenSize.screenHeight * 0.0175 +
                ScreenSize.screenWidth * 0.0175,
          ),
        ),
        borderRadius: 0,
        maxWidth: ScreenSize.screenWidth,
        margin: EdgeInsets.zero,
      );
      await Future.delayed(duration);
      _activated = false;
    }
  }

  // Function to close a snackbar if any is currently open
  static void closeSnackbar() {
    _activated = false;
    Get.closeCurrentSnackbar();
  }
}