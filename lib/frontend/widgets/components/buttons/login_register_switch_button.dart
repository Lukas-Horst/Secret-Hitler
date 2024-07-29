// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';
import 'package:secret_hitler/frontend/widgets/components/transformed_widgets/angle_widget.dart';

// The whole area on the login or register page where we switch the pages
class LoginRegisterSwitchButton extends StatelessWidget {

  final String questionText;
  final String buttonText;
  final Function onTap;

  const LoginRegisterSwitchButton({super.key, required this.questionText,
    required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AngleWidget(
          angleDegree: 330,
          child: Image.asset(
            'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenHeight * 0.07,
          ),
        ),
        Column(
          children: [
            Text(
              questionText,
              style: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                fontSize: ScreenSize.screenHeight * 0.017 +
                    ScreenSize.screenWidth * 0.017,
                color: Colors.white,
              ),
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.005),
            CustomTextButton(
              text: buttonText,
              textStyle: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                fontSize: ScreenSize.screenHeight * 0.017 +
                    ScreenSize.screenWidth * 0.017,
                color: AppDesign.getContraryPrimaryColor(),
                decoration: TextDecoration.underline,
              ),
              onTap: () {onTap();},
            ),
          ],
        ),
        AngleWidget(
          angleDegree: -330,
          child: Image.asset(
            'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenHeight * 0.07,
          ),
        ),
      ],
    );
  }
}