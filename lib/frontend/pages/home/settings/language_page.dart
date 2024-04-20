// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  final String _currentLanguage = AppLanguage.getCurrentLanguage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            Header(headerText: AppLanguage.getLanguageData()['Language']),
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            ExplainingText(
              text: AppLanguage.getLanguageData()['Choose your language.'],
            ),
            SizedBox(
              height: ScreenSize.screenHeight * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PrimaryElevatedButton(
                    text: AppLanguage.getLanguageData()['German'],
                    onPressed: () async {
                      await AppLanguage.setCurrentLanguage('de');
                      setState(()  {});
                    },
                  ),
                  PrimaryElevatedButton(
                    text: AppLanguage.getLanguageData()['English'],
                    onPressed: () async {
                      await AppLanguage.setCurrentLanguage('en');
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationBackButton(onPressed: () {
            // If the language changed, we load the settings page again
            if (_currentLanguage != AppLanguage.getCurrentLanguage()) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PageNavigation(startPage: 2,)),);
            } else {
              Navigator.pop(context);
            }},
          ),
        ],
      ),
    );
  }
}
