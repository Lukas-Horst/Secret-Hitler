// author: Lukas Horst

import 'package:flutter/material.dart';

// Text button without too much space around
class CustomTextButton extends StatefulWidget {

  final String text;
  final TextStyle textStyle;
  final Function() onTap;

  const CustomTextButton({super.key, required this.text,
    required this.textStyle, required this.onTap});

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: RichText(
        text: TextSpan(
          text: widget.text,
          style: widget.textStyle,
        ),
      ),
    );
  }
}