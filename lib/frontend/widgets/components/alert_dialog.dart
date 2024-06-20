// author: Lukas Horst

// Class to activate or deactivate a custom alert dialog
import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class CustomAlertDialog {
  static bool _activated = false;

  static Future<void> showAlertDialog(String title, String content,
      BuildContext context, Duration duration) async {
    _activated = true;
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'EskapadeFrakturW04BlackFamily',
            color: Colors.white,
            fontSize: ScreenSize.screenHeight * 0.0225 +
                ScreenSize.screenWidth * 0.0225,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontFamily: 'EskapadeFrakturW04BlackFamily',
            color: Colors.white,
            fontSize: ScreenSize.screenHeight * 0.015 +
                ScreenSize.screenWidth * 0.015,
          ),
        ),
      );
    });
    await Future.delayed(duration);
    Navigator.of(context).pop();
    _activated = false;
  }
}