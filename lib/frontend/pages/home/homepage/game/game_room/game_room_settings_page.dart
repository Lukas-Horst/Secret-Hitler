// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_naviagtion.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';

class GameRoomSettings extends StatefulWidget {

  const GameRoomSettings({super.key,});

  @override
  State<GameRoomSettings> createState() => _GameRoomSettingsState();
}

class _GameRoomSettingsState extends State<GameRoomSettings> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PrimaryElevatedButton(
          text: AppLanguage.getLanguageData()['Rules'],
          onPressed: () {
            newPage(context, const RulesNavigation());
          },
        ),
        PrimaryElevatedButton(
          text: AppLanguage.getLanguageData()['Leave'],
          onPressed: () {
            closePage(context, 1);
          },
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
