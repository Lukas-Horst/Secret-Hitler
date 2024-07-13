// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text/stroke_text.dart';

class RulesPage4 extends StatelessWidget {
  const RulesPage4({super.key});

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
                text: AppLanguage.getLanguageData()['RulePage4Section1'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section2'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section3'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['Election Tracker'] + ':',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section4'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section5'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: '${AppLanguage.getLanguageData()['About lying'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section6'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: const Color(0xffDC3B06),
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section7'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section8'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage4Section9'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
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