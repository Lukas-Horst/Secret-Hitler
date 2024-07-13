// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// Text with a stroke style
class StrokeText extends StatefulWidget {

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
  State<StrokeText> createState() => _StrokeTextState();
}

class _StrokeTextState extends State<StrokeText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ScreenSize.screenWidth * 0.005),
      child: Stack(
        children: [
          // Stroke text
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: widget.fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = widget.strokeWidth
                ..color = widget.strokeColor,
            ),
          ),
          // Main text
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: widget.fontSize,
              color: widget.textColor,
              decoration: widget.underline
                  ? TextDecoration.underline
                  : null,
              decorationColor: widget.textColor,
            ),
          ),

        ],
      ),
    );
  }
}