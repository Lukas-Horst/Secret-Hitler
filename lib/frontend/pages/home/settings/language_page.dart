// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Language extends StatefulWidget {

  final Function refresh;

  const Language({super.key, required this.refresh});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  final String _currentLanguage = AppLanguage.getCurrentLanguage();

  void _goBack(BuildContext context) {
    // If the language changed, we refresh the settings page
    if (_currentLanguage != AppLanguage.getCurrentLanguage()) {
      widget.refresh();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              _goBack(context);
            }),
          ],
        ),
      ),
    );
  }
}
