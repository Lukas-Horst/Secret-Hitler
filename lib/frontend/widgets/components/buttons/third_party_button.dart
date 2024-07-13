// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

// The button to log in with a third party provider
class ThirdPartyButton extends StatefulWidget {

  final String imageName;
  final Function onPressed;

  const ThirdPartyButton({super.key, required this.imageName,
    required this.onPressed});

  @override
  State<ThirdPartyButton> createState() => _ThirdPartyButtonState();
}

class _ThirdPartyButtonState extends State<ThirdPartyButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {widget.onPressed();},
      icon: Image.asset(
        'assets/images/${widget.imageName}.png',
      ),
      style: IconButton.styleFrom(
          backgroundColor: AppDesign.getSecondaryColor(),
          foregroundColor: Colors.black,
          fixedSize: Size(
            ScreenSize.screenWidth * 0.2125,
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
    );
  }
}