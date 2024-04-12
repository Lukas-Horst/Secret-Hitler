// author: Lukas Horst

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
        constraints: BoxConstraints(
          maxWidth: widget.width,
          maxHeight: widget.height,
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
          fontSize: ScreenSize.screenHeight * 0.016 +
              ScreenSize.screenWidth * 0.016,
        ),
      ),
      style: TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        color: Colors.black,
        fontSize: ScreenSize.screenHeight * 0.016 +
            ScreenSize.screenWidth * 0.016,
        overflow: TextOverflow.ellipsis,
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
    );
  }
}
