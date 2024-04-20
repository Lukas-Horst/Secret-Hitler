// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/settings/language_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: ScreenSize.screenHeight * 0.02),
          Header(headerText: AppLanguage.getLanguageData()['Settings']),
          SizedBox(height: ScreenSize.screenHeight * 0.08),
          // Buttons
          SizedBox(
            height: ScreenSize.screenHeight * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Language'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Language()),
                    );
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Design'],
                  onPressed: () {},
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Imprint'],
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}