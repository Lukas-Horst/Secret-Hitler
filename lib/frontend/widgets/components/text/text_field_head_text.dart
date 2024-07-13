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