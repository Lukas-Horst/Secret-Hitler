// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The standard design for the explaining text beyond the header
class ExplainingText extends StatelessWidget {

  final String text;

  const ExplainingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.screenWidth * 0.85,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          color: Colors.white,
          fontSize: ScreenSize.screenHeight * 0.02 +
              ScreenSize.screenWidth * 0.02,
        ),
      ),
    );
  }
}