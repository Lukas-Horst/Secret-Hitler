// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class DividerWithText extends StatelessWidget {

  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 3,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth * 0.02),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: ScreenSize.screenHeight * 0.02 +
                  ScreenSize.screenWidth * 0.02,
              color: Colors.white,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 3,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
