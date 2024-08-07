import 'package:flutter/material.dart' show BuildContext, MediaQuery;

// Class to get the screen size globally
class ScreenSize {
  static late double screenWidth;
  static late double screenHeight;
  static late double bottomViewInsets;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bottomViewInsets = MediaQuery.of(context).viewInsets.bottom;
  }
}