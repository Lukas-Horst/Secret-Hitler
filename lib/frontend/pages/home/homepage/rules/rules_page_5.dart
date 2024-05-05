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
              StrokeText(
                text: '${AppLanguage.getLanguageData()['Investigate Loyalty'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/Investigate_Loyalty_White.png',
                    height: ScreenSize.screenHeight * 0.125,
                    width: ScreenSize.screenWidth * 0.25,
                  ),
                  SizedBox(width: ScreenSize.screenWidth * 0.03),
                  Expanded(
                    child: StrokeText(
                      text: AppLanguage.getLanguageData()['RulePage5Section2'].toString().substring(0, _investigateLoyaltyTextIndex),
                      fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                      textColor: Colors.white,
                      strokeWidth: 4,
                      strokeColor: Colors.black,
                      underline: false,
                    ),
                  ),
                ],
              ),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section2'].toString().substring(_investigateLoyaltyTextIndex),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: '${AppLanguage.getLanguageData()['Call Special Election'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/Call_Special_Election_White.png',
                    height: ScreenSize.screenHeight * 0.1,
                    width: ScreenSize.screenWidth * 0.25,
                  ),
                  SizedBox(width: ScreenSize.screenWidth * 0.03),
                  Expanded(
                    child: StrokeText(
                      text: AppLanguage.getLanguageData()['RulePage5Section3'].toString().substring(0, _callSpecialElectionTextIndex),
                      fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                      textColor: Colors.white,
                      strokeWidth: 4,
                      strokeColor: Colors.black,
                      underline: false,
                    ),
                  ),
                ],
              ),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section3'].toString().substring(_callSpecialElectionTextIndex),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
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
              StrokeText(
                text: '${AppLanguage.getLanguageData()['Policy Peek'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/Policy_Peek_White.png',
                    height: ScreenSize.screenHeight * 0.1,
                    width: ScreenSize.screenWidth * 0.25,
                  ),
                  SizedBox(width: ScreenSize.screenWidth * 0.03),
                  Expanded(
                    child: StrokeText(
                      text: AppLanguage.getLanguageData()['RulePage5Section6'].toString().substring(0, _policyPeekTextIndex),
                      fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                      textColor: Colors.white,
                      strokeWidth: 4,
                      strokeColor: Colors.black,
                      underline: false,
                    ),
                  ),
                ],
              ),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section6'].toString().substring(_policyPeekTextIndex),
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              StrokeText(
                text: '${AppLanguage.getLanguageData()['Execution'].toString().toUpperCase()}:',
                fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                textColor: Colors.white,
                strokeWidth: 4,
                strokeColor: Colors.black,
                underline: false,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.0001),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/Execution_White.png',
                    height: ScreenSize.screenHeight * 0.1,
                    width: ScreenSize.screenWidth * 0.25,
                  ),
                  SizedBox(width: ScreenSize.screenWidth * 0.03),
                  Expanded(
                    child: StrokeText(
                      text: AppLanguage.getLanguageData()['RulePage5Section7'].toString().substring(0, _executionTextIndex),
                      fontSize: ScreenSize.screenHeight * 0.015 + ScreenSize.screenWidth * 0.015,
                      textColor: Colors.white,
                      strokeWidth: 4,
                      strokeColor: Colors.black,
                      underline: false,
                    ),
                  ),
                ],
              ),
              StrokeText(
                text: AppLanguage.getLanguageData()['RulePage5Section7'].toString().substring(_executionTextIndex),
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