// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Text with a stroke style
class StrokeText extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color textColor;
  final bool underline;
  final double strokeWidth;
  final Color strokeColor;

  const StrokeText({super.key, required this.text, required this.fontSize,
    required this.textColor, required this.strokeWidth,
    required this.strokeColor, required this.underline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ScreenSize.screenWidth * 0.005),
      child: Stack(
        children: [
          // Stroke text
          Text(
            text,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = strokeColor,
            ),
          ),
          // Main text
          Text(
            text,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: fontSize,
              color: textColor,
              decoration: underline
                  ? TextDecoration.underline
                  : null,
              decorationColor: textColor,
            ),
          ),

        ],
      ),
    );
  }
}