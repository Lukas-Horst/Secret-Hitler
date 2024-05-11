// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/string_functions.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';

class RulesPage5 extends StatefulWidget {
  const RulesPage5({super.key});

  @override
  State<RulesPage5> createState() => _RulesPage5State();
}

class _RulesPage5State extends State<RulesPage5> {

  late int _investigateLoyaltyTextIndex;
  late int _callSpecialElectionTextIndex;
  late int _policyPeekTextIndex;
  late int _executionTextIndex;

  @override
  void initState() {
    _investigateLoyaltyTextIndex = StringFunctions.calculateTextWidth(
      AppLanguage.getLanguageData()['RulePage5Section2'],
      TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      ScreenSize.screenWidth * 0.68,
      ScreenSize.screenHeight * 0.125,
    );
    _callSpecialElectionTextIndex = StringFunctions.calculateTextWidth(
      AppLanguage.getLanguageData()['RulePage5Section3'],
      TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      ScreenSize.screenWidth * 0.68,
      ScreenSize.screenHeight * 0.1,
    );
    _policyPeekTextIndex = StringFunctions.calculateTextWidth(
      AppLanguage.getLanguageData()['RulePage5Section6'],
      TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      ScreenSize.screenWidth * 0.68,
      ScreenSize.screenHeight * 0.1,
    );
    _executionTextIndex = StringFunctions.calculateTextWidth(
      AppLanguage.getLanguageData()['RulePage5Section7'],
      TextStyle(
        fontFamily: 'EskapadeFrakturW04BlackFamily',
        fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      ScreenSize.screenWidth * 0.68,
      ScreenSize.screenHeight * 0.1,
    );
    super.initState();
  }

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
                text: AppLanguage.getLanguageData()['Executive Action'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: true,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.005),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section1'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              StrokeText(
                text: AppLanguage.getLanguageData()['Presidential Powers'].toString().toUpperCase(),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: true,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.015),
              TextWithImage(
                imageName: 'Investigate_Loyalty_White',
                imageHeight: ScreenSize.screenHeight * 0.125,
                imageWidth: ScreenSize.screenWidth * 0.25,
                text: AppLanguage.getLanguageData()['RulePage5Section2'].toString(),
                textIndex: _investigateLoyaltyTextIndex,
                headline: 'Call Special Election',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              TextWithImage(
                imageName: 'Call_Special_Election_White',
                imageHeight: ScreenSize.screenHeight * 0.1,
                imageWidth: ScreenSize.screenWidth * 0.25,
                text: AppLanguage.getLanguageData()['RulePage5Section3'].toString(),
                textIndex: _callSpecialElectionTextIndex,
                headline: 'Call Special Election',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section4'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section5'],
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              TextWithImage(
                imageName: 'Policy_Peek_White',
                imageHeight: ScreenSize.screenHeight * 0.1,
                imageWidth: ScreenSize.screenWidth * 0.25,
                text: AppLanguage.getLanguageData()['RulePage5Section6'].toString(),
                textIndex: _policyPeekTextIndex,
                headline: 'Policy Peek',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              TextWithImage(
                imageName: 'Execution_White',
                imageHeight: ScreenSize.screenHeight * 0.1,
                imageWidth: ScreenSize.screenWidth * 0.25,
                text: AppLanguage.getLanguageData()['RulePage5Section7'].toString(),
                textIndex: _executionTextIndex,
                headline: 'Execution',
              ),
            ],
          ),
        ),
      ),
    );
  }
}