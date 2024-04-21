// author: Lukas Horst

import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

class HeaderImage {

  static bool newHeader = true;
  static late String headerImage;

  // Method to get a random image for the header
  static String getHeaderImage(Color headerColor) {
    if (newHeader) {
      newHeader = false;
      late List<String> headerImages;
      if (headerColor == const Color(0xff479492)) {
        headerImages = ['Liberal_1', 'Liberal_2', 'Liberal_3', 'Liberal_4'];
      } else {
        headerImages = ['Fascist_1', 'Fascist_2', 'Hitler'];
      }

      // Getting a random image
      Random random = math.Random();
      int randomIndex = random.nextInt(headerImages.length);
      headerImage = headerImages[randomIndex];

      // The timer is there to avoid that the header image switch at the app start
      Timer(const Duration(seconds: 2), () {
        newHeader = true;
      });
    }
    return headerImage;
  }

  // To avoid that we get a wrong image if we change the color
  static void resetNewHeader() {
    newHeader = true;
  }
}