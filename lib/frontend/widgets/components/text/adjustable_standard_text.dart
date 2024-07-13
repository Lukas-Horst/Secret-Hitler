// author: Lukas Horst

import 'package:flutter/material.dart';

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