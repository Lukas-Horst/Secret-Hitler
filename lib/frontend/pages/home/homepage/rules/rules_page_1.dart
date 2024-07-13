// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text/stroke_text.dart';

class RulesPage1 extends StatelessWidget {
  const RulesPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: ScreenSize.screenWidth * 0.98,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage1Section1'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              Center(
                child: StrokeText(
                  text: AppLanguage.getLanguageData()['Overview'].toString().toUpperCase(),
                  fontSize: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
                  textColor: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.black,
                  underline: true,
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage1Section2'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage1Section3'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage1Section4'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
