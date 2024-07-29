// author: Lukas Horst

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/animations/moving_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/text/stroke_text.dart';

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
  State<CustomTextFormField> createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String? _errorStatus;
  bool _errorMessageVisible = false;
  String _errorMessage = '';
  late bool _textEditingActive;
  final double _fontSize = ScreenSize.screenHeight * 0.018 +
      ScreenSize.screenWidth * 0.016;
  final GlobalKey<MovingAnimationState> _errorTextMovingKey = GlobalKey<MovingAnimationState>();

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
    return null;
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

  // Giving the error status a value and showing the error message
  void showError(String message) {
    _errorStatus = '';
    setState(() {
      _errorMessage = message;
    });
    _validate();
  }

  // Setting the error status to null and covers the error message
  bool resetsErrors() {
    if (_errorStatus != null) {
      _errorStatus = null;
      _validate();
      return true;
    }
    return false;
  }

  void _validate() {
    _formKey.currentState?.validate();
  }

  @override
  void initState() {
    _textEditingActive = widget.readOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          MovingAnimation(
            key: _errorTextMovingKey,
            duration: const Duration(milliseconds: 350),
            firstLeftPosition: ScreenSize.screenWidth * 0.025,
            firstTopPosition: ScreenSize.screenHeight * 0.025,
            secondLeftPosition: ScreenSize.screenWidth * 0.025,
            secondTopPosition: ScreenSize.screenHeight * 0.065,
            child: StrokeText(
              text: _errorMessage,
              fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
              textColor: const Color(0xFF960202),
              strokeWidth: 3,
              strokeColor: Colors.black,
              underline: false,
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF960202),
                    width: 3,
                  ),
                ),
                errorStyle: const TextStyle(
                  fontSize: 0,
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
              validator: (value) {
                if (!_errorMessageVisible && _errorStatus != null) {
                  _errorMessageVisible = true;
                  _errorTextMovingKey.currentState?.animate();
                } else if (_errorMessageVisible && _errorStatus == null) {
                  _errorMessageVisible = false;
                  _errorTextMovingKey.currentState?.animate();
                }
                return _errorStatus;
              },
            ),
          ),
        ],
      ),
    );
  }
}
