// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text/stroke_text.dart';

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