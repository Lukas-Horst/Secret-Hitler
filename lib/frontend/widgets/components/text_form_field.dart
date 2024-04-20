// author: Lukas Horst

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class CustomTextFormField extends StatefulWidget {

  final String hintText;
  final bool obscureText;
  final TextEditingController textController;
  final bool readOnly;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final bool autoFocus;
  final double width;
  final double height;

  const CustomTextFormField({super.key, required this.hintText,
    required this.obscureText, required this.textController, required this.readOnly,
    this.currentFocusNode, this.nextFocusNode, required this.autoFocus,
    required this.width, required this.height});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  bool _passwordVisible = false;
  final double _maxFontSize = ScreenSize.screenHeight * 0.018 +
      ScreenSize.screenWidth * 0.016;
  double _fontSize = ScreenSize.screenHeight * 0.018 +
      ScreenSize.screenWidth * 0.016;
  late double _maxWidth;
  int _textLength = 0;

  // Methode to adjust the text length, to have it always in one line
  void _adjustTextLength(value) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          color: Colors.black,
          fontSize: _fontSize,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: _maxWidth);

    // Detecting if text was added or deleted
    bool textAdded = _textLength < value.length;

    if (textPainter.maxIntrinsicWidth > _maxWidth && textAdded) {
      setState(() {
        _fontSize *= 0.90;
      });
      // Adjust it so often until it fits
      _adjustTextLength(value);
    } else if (textPainter.maxIntrinsicWidth < _maxWidth * 0.95 &&
        _fontSize < _maxFontSize && !textAdded) {
      setState(() {
        _fontSize = min(_fontSize * 1.1, _maxFontSize);
        _adjustTextLength(value);
      });
    } else {
      _textLength = value.length;
    }
  }

  @override
  void initState() {
    if (widget.obscureText) {
      _maxWidth = ScreenSize.screenWidth * 0.63;
    } else {
      _maxWidth = ScreenSize.screenWidth * 0.7;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      obscureText: (widget.obscureText)? !_passwordVisible : false,
      readOnly: widget.readOnly,
      focusNode: widget.currentFocusNode,
      onFieldSubmitted: (value) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
        // Background color
        filled: true,
        fillColor: AppDesign.getPrimaryColor(),
        // Size
        contentPadding: EdgeInsets.fromLTRB(ScreenSize.screenWidth * 0.03, ScreenSize.screenHeight * 0.03, 0, 0),
        constraints: BoxConstraints(
          maxWidth: widget.width,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: widget.readOnly ? 3.0 : 1.5,
          ),
        ),
        // hide button for the password
        suffixIcon: (widget.obscureText)? IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            size: ScreenSize.screenHeight * 0.025 +
                ScreenSize.screenWidth * 0.025,
          ),
        ) : null,
        suffixIconColor: Colors.black,
        // Style for the text
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          fontSize: _fontSize,
        ),
      ),
      style: TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        color: Colors.black,
        fontSize: _fontSize,
        overflow: TextOverflow.ellipsis,
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
      onChanged: (value) {
        _adjustTextLength(value);
      },
    );
  }
}
