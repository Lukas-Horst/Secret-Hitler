// author: Lukas Horst

import 'package:flutter/material.dart';

// Text button without too much space around
class CustomTextButton extends StatelessWidget {

  final String text;
  final TextStyle textStyle;
  final Function() onTap;

  const CustomTextButton({super.key, required this.text,
    required this.textStyle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text,
          style: textStyle,
        ),
      ),
    );
  }
}