// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The standard design for the text above the text field
class TextFieldHeadText extends StatefulWidget {

  final String text;

  const TextFieldHeadText({super.key, required this.text});

  @override
  State<TextFieldHeadText> createState() => _TextFieldHeadTextState();
}

class _TextFieldHeadTextState extends State<TextFieldHeadText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text}:',
      style: TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        color: Colors.white,
        fontSize: ScreenSize.screenHeight * 0.025 +
            ScreenSize.screenWidth * 0.025,
      ),
    );
  }
}

// The standard design for the explaining text beyond the header
class ExplainingText extends StatefulWidget {

  final String text;

  const ExplainingText({super.key, required this.text});

  @override
  State<ExplainingText> createState() => _ExplainingTextState();
}

class _ExplainingTextState extends State<ExplainingText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.screenWidth * 0.85,
      child: Text(
        widget.text,
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


