// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text/stroke_text.dart';

class RulesPage2 extends StatelessWidget {
  const RulesPage2({super.key});

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
                  text: AppLanguage.getLanguageData()['Goal'].toString().toUpperCase(),
                  fontSize: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
                  textColor: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.black,
                  underline: true,
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section1'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.9,
                  child: StrokeText(
                    text: AppLanguage.getLanguageData()['RulePage2Section2'],
                    fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                    textColor: Colors.white,
                    strokeWidth: 4,
                    strokeColor: Colors.black,
                    underline: false,
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['Or'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.9,
                  child: StrokeText(
                    text: AppLanguage.getLanguageData()['RulePage2Section3'],
                    fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                    textColor: Colors.white,
                    strokeWidth: 4,
                    strokeColor: Colors.black,
                    underline: false,
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section4'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.9,
                  child: StrokeText(
                    text: AppLanguage.getLanguageData()['RulePage2Section5'],
                    fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                    textColor: Colors.white,
                    strokeWidth: 4,
                    strokeColor: Colors.black,
                    underline: false,
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['Or'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              Center(
                child: SizedBox(
                  width: ScreenSize.screenWidth * 0.9,
                  child: StrokeText(
                    text: AppLanguage.getLanguageData()['RulePage2Section6'],
                    fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                    textColor: Colors.white,
                    strokeWidth: 4,
                    strokeColor: Colors.black,
                    underline: false,
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              Center(
                child: StrokeText(
                  text: AppLanguage.getLanguageData()['Game Contents'].toString().toUpperCase(),
                  fontSize: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
                  textColor: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.black,
                  underline: true,
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section7'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section8'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section9'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section10'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section11'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section12'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section13'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section14'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section15'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section16'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage2Section17'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.014 + ScreenSize.screenWidth * 0.014,
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