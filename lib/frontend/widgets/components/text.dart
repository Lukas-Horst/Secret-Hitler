// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
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

// Used on rules page 5
class TextWithImage extends StatefulWidget {

  final String headline;
  final String imageName;
  final double imageHeight;
  final double imageWidth;
  final String text;
  final int textIndex;

  const TextWithImage({super.key, required this.imageName,
    required this.imageHeight, required this.imageWidth,
    required this.text, required this.textIndex, required this.headline});

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StrokeText(
          text: '${AppLanguage.getLanguageData()[widget.headline].toString().toUpperCase()}:',
          fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
          textColor: Colors.white,
          strokeWidth: 4,
          strokeColor: Colors.black,
          underline: false,
        ),
        SizedBox(height: ScreenSize.screenHeight * 0.0001),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/${widget.imageName}.png',
              height: widget.imageHeight,
              width: widget.imageWidth,
            ),
            SizedBox(width: ScreenSize.screenWidth * 0.03),
            Expanded(
              child: StrokeText(
                text: widget.text.substring(0, widget.textIndex),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
            ),
          ],
        ),
        StrokeText(
          text: widget.text.substring(widget.textIndex),
          fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
          textColor: Colors.white,
          strokeWidth: 4,
          strokeColor: Colors.black,
          underline: false,
        ),
      ],
    );
  }
}

// The standard text with the right font family
class AdjustableStandardText extends StatefulWidget {

  final String text;
  final Color color;
  final double size;
  final bool? underline;

  const AdjustableStandardText({super.key, required this.text,
    required this.color, required this.size, this.underline});

  @override
  State<AdjustableStandardText> createState() => _AdjustableStandardTextState();
}

class _AdjustableStandardTextState extends State<AdjustableStandardText> {

  late bool _underline;

  @override
  void initState() {
    if (widget.underline != null) {
      _underline = widget.underline!;
    } else {
      _underline = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        color: widget.color,
        fontSize: widget.size,
        decoration: _underline
            ? TextDecoration.underline
            : null,
        decorationColor: widget.color,
      ),
    );
  }
}


