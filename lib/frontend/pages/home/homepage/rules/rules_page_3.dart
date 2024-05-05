// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';

class RulesPage3 extends StatelessWidget {
  const RulesPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: ScreenSize.screenWidth * 0.98,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: StrokeText(
                  text: AppLanguage.getLanguageData()['Gameplay'].toString().toUpperCase(),
                  fontSize: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
                  textColor: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.black,
                  underline: true,
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section1'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['Election'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: true,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.005),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section2'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: true,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section3'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section4'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: true,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section5'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['Eligibility'] + ':',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section6'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: '${AppLanguage.getLanguageData()['On Eligibility'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section7'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section8'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section9'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage3Section10'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}