// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/join_game/join_game_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/new_game_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_naviagtion.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/loading_spin.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingSpin.closeLoadingSpin(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Header(headerText: 'Homepage'),
          SizedBox(height: ScreenSize.screenHeight * 0.08),
          // Buttons
          SizedBox(
            height: ScreenSize.screenHeight * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['New Game'],
                  onPressed: () {
                    newPage(context, const NewGame());
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Join Game'],
                  onPressed: () {
                    newPage(context, const JoinGame());
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Rules'],
                  onPressed: () {
                    newPage(context, const RulesNavigation());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
