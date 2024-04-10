// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/database/hive_database.dart';

class AppDesign {

  static late Color _currentPrimaryColor;
  static late Color _currentSecondaryColor;

  static Future<void> init() async {
    String? color = await HiveDatabase.getValue('color');
    if (color != null) {
      _currentPrimaryColor = Color(int.parse(color, radix: 16));
    } else {
      // The standard color is red (fascist design)
      _currentPrimaryColor = const Color(0xffDC3B06);
      await HiveDatabase.insertData('color', _currentPrimaryColor.value.toRadixString(16));
    }
    _setSecondaryColor();
  }
  
  static Color getPrimaryColor() {
    return _currentPrimaryColor;
  }

  static Color getSecondaryColor() {
    return _currentSecondaryColor;
  }

  // Method to set the primary color and save it in the database
  static Future<void> setPrimaryColor(Color color) async {
    _currentPrimaryColor = color;
    _setSecondaryColor();
    await HiveDatabase.insertData('color', _currentPrimaryColor.value.toRadixString(16));
  }

  // Method to set the secondary Color based on the primary color
  static void _setSecondaryColor() {
    if (_currentPrimaryColor == const Color(0xffDC3B06)) {
      _currentSecondaryColor = const Color(0xffDC0606);
    } else {
      _currentSecondaryColor = const Color(0xff004D65);
    }
  }
}