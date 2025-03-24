// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';

// Class to activate or deactivate a custom alert dialog
class CustomAlertDialog {
  static bool _activated = false;

  static Future<void> showAlertDialog(String title, String content,
      BuildContext context) async {
    if (!_activated) {
      _activated = true;
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              color: Colors.white,
              fontSize: ScreenSize.screenHeight * 0.0225 +
                  ScreenSize.screenWidth * 0.0225,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              color: Colors.white,
              fontSize: ScreenSize.screenHeight * 0.015 +
                  ScreenSize.screenWidth * 0.015,
            ),
          ),
          actions: [
            CustomTextButton(
              text: AppLanguage.getLanguageData()['Yes'],
              textStyle: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: AppDesign.getContraryPrimaryColor(),
                fontSize: ScreenSize.screenHeight * 0.0225 +
                    ScreenSize.screenWidth * 0.0225,
                decoration: TextDecoration.underline,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            SizedBox(width: ScreenSize.screenWidth * 0.015,),
            CustomTextButton(
              text: AppLanguage.getLanguageData()['No'],
              textStyle: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: AppDesign.getContraryPrimaryColor(),
                fontSize: ScreenSize.screenHeight * 0.0225 +
                    ScreenSize.screenWidth * 0.0225,
                decoration: TextDecoration.underline,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
      _activated = false;
    }
  }
}