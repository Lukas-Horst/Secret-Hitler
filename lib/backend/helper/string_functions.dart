// author: Lukas Horst

import 'package:flutter/material.dart';

class StringFunctions {

  // Method to calculate how much of an text goes in a container
  static int calculateTextWidth(String text, TextStyle style,
      double containerWidth, double containerHeight) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 999,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: containerWidth);

    // Calculate the max index of the text who fits in the container
    int maxIndex = 0;
    for (int i = 0; i < text.length; i++) {
      TextPainter tempPainter = TextPainter(
        text: TextSpan(text: text.substring(0, i + 1), style: style),
        maxLines: 999,
        textDirection: TextDirection.ltr,
      );
      tempPainter.layout(maxWidth: containerWidth);
      double totalHeight = tempPainter.height;
      if (totalHeight > containerHeight) {
        break;
      }
      maxIndex = i;
    }
    maxIndex = _adjustSubstring(maxIndex, text);
    return maxIndex + 1;
  }

  // Method to check if the substring ends with a full word
  static bool _checkSubstring(int stringEnd, String text) {
    // If the last character is space the substring is correct
    if (text.substring(stringEnd, stringEnd + 1) == ' ') {
      return true;
    // If the next character is space the substring is also correct
    } else if (text.substring(stringEnd + 1, stringEnd + 2) == ' ') {
      return true;
    } else {
      return false;
    }
  }

  // Method to delete the last characters of a substring if these aren't a full word
  static int _adjustSubstring(int stringEnd, String text) {
    if (_checkSubstring(stringEnd, text)) {
      return stringEnd;
    } else {
      return _adjustSubstring(stringEnd - 1, text);
    }
  }
}