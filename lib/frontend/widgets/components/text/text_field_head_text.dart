// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The standard design for the text above the text field
class TextFieldHeadText extends StatelessWidget {

  final String text;

  const TextFieldHeadText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text:',
      style: TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        color: Colors.white,
        fontSize: ScreenSize.screenHeight * 0.025 +
            ScreenSize.screenWidth * 0.025,
      ),
    );
  }
}