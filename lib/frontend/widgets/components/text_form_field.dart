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
  late bool _textEditingActive;
  final double _fontSize = ScreenSize.screenHeight * 0.018 +
      ScreenSize.screenWidth * 0.016;

  // Method to get the right suffix icon based on the given widget parameters
  Widget? _getSuffixIcon() {
    if (widget.readOnly) {
      return IconButton(
        onPressed: () {
          _changeTextEditingStatus();
        },
        icon: Icon(
          _textEditingActive
              ? Icons.edit
              : Icons.check,
          size: ScreenSize.screenHeight * 0.025 +
              ScreenSize.screenWidth * 0.025,
        ),
      );
    } else if (widget.obscureText) {
      return IconButton(
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
      );
    }
  }

  void _changeTextEditingStatus() {
    setState(() {
      _textEditingActive = !_textEditingActive;
      if (!_textEditingActive) {
        // Focus on the text field if we click on the edit button
        FocusScope.of(context).requestFocus(widget.currentFocusNode);
      }
    });
  }

  @override
  void initState() {
    _textEditingActive = widget.readOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      obscureText: (widget.obscureText)? !_passwordVisible : false,
      readOnly: _textEditingActive,
      focusNode: widget.currentFocusNode,
      onFieldSubmitted: (value) {
        if (widget.readOnly) {
          _changeTextEditingStatus();
        } else if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
        // Background color
        filled: true,
        fillColor: AppDesign.getPrimaryColor(),
        // Size
        contentPadding: EdgeInsets.fromLTRB(ScreenSize.screenWidth * 0.03,
            ScreenSize.screenHeight * 0.03, ScreenSize.screenWidth * 0.03, 0
        ),
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
        suffixIcon: _getSuffixIcon(),
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
    );
  }
}
