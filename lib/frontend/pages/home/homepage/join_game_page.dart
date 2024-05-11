// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Header(headerText: AppLanguage.getLanguageData()['Join Game']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavigationBackButton(onPressed: () {
                goBack(context);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
