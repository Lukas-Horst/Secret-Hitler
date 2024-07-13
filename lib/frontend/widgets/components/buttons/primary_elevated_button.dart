// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The standard elevated button design
class PrimaryElevatedButton extends StatefulWidget {

  final String text;
  final Function() onPressed;
  final double? textSize;

  const PrimaryElevatedButton({super.key, required this.text,
    required this.onPressed, this.textSize});

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
          fontSize: widget.textSize ?? ScreenSize.screenHeight * 0.025 +
              ScreenSize.screenWidth * 0.025,
        ),
      ),
    );
  }
}