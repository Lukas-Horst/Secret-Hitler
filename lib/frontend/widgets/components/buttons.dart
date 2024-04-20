// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

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

// The standard elevated button design
class PrimaryElevatedButton extends StatefulWidget {

  final String text;
  final Function() onPressed;

  const PrimaryElevatedButton({super.key, required this.text, required this.onPressed});

  @override
  State<PrimaryElevatedButton> createState() => _PrimaryElevatedButtonState();
}

class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.getSecondaryColor(),
          foregroundColor: Colors.black,
          fixedSize: Size(
            ScreenSize.screenWidth * 0.85,
            ScreenSize.screenHeight * 0.065,
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          )
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          fontSize: ScreenSize.screenHeight * 0.025 +
              ScreenSize.screenWidth * 0.025,
        ),
      ),
    );
  }
}

// The back button on the navigation bar
class NavigationBackButton extends StatefulWidget {

  final Function() onPressed;

  const NavigationBackButton({super.key, required this.onPressed});

  @override
  State<NavigationBackButton> createState() => _NavigationBackButtonState();
}

class _NavigationBackButtonState extends State<NavigationBackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: ScreenSize.screenHeight * 0.04 +
            ScreenSize.screenWidth * 0.04,
        color: Colors.white,
      ),
      onPressed: widget.onPressed,
    );
  }
}

