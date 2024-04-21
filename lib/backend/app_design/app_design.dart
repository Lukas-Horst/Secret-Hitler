// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/database/hive_database.dart';
import 'package:secret_hitler/frontend/widgets/header/header_image.dart';

class AppDesign {

  static late Color _currentPrimaryColor;
  static late Color _currentSecondaryColor;
  static late Color _currentTertiaryColor;
  static late Color _contraryPrimaryColor;
  static late Color _contrarySecondaryColor;
  static late String _currentCirclePNG;

  static Future<void> init() async {
    String? color = await HiveDatabase.getValue('color');
    if (color != null) {
      _currentPrimaryColor = Color(int.parse(color, radix: 16));
    } else {
      // The standard color is red (fascist design)
      _currentPrimaryColor = const Color(0xffDC3B06);
      await HiveDatabase.insertData('color', _currentPrimaryColor.value.toRadixString(16));
    }
    _update();
  }

  // Methode to update all attributes
  static void _update() {
    _setSecondaryColor();
    _setTertiaryColor();
    _setContraryPrimaryColor();
    _setContrarySecondaryColor();
    _setCirclePNG();
  }
  
  static Color getPrimaryColor() {
    return _currentPrimaryColor;
  }

  static Color getSecondaryColor() {
    return _currentSecondaryColor;
  }

  static Color getTertiaryColor() {
    return _currentTertiaryColor;
  }

  static Color getContraryPrimaryColor() {
    return _contraryPrimaryColor;
  }

  static Color getContrarySecondaryColor() {
    return _contrarySecondaryColor;
  }

  static String getCirclePNG() {
    return _currentCirclePNG;
  }

  // Method to set the primary color and save it in the database
  static Future<void> setPrimaryColor(Color color) async {
    _currentPrimaryColor = color;
    _update();
    HeaderImage.resetNewHeader();
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

  // Method to set the tertiary Color based on the primary color
  static void _setTertiaryColor() {
    if (_currentPrimaryColor == const Color(0xffDC3B06)) {
      _currentTertiaryColor = const Color(0xff571C00);
    } else {
      _currentTertiaryColor = const Color(0xff18312C);
    }
  }

  // Method to set the contrary primary Color based on the primary color
  static void _setContraryPrimaryColor() {
    if (_currentPrimaryColor == const Color(0xffDC3B06)) {
      _contraryPrimaryColor= const Color(0xff479492);
    } else {
      _contraryPrimaryColor = const Color(0xffDC3B06);
    }
  }

  // Method to set the contrary secondary Color based on the primary color
  static void _setContrarySecondaryColor() {
    if (_currentPrimaryColor == const Color(0xffDC3B06)) {
      _contrarySecondaryColor= const Color(0xff004D65);
    } else {
      _contrarySecondaryColor = const Color(0xffDC0606);
    }
  }

  static void _setCirclePNG() {
    if (_currentPrimaryColor == const Color(0xffDC3B06)) {
      _currentCirclePNG = 'fascist_circle';
    } else {
      _currentCirclePNG = 'liberal_circle';
    }
  }
}