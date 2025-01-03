// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/frontend/pages/home/settings/design_page.dart';
import 'package:secret_hitler/frontend/pages/home/settings/language_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Settings extends ConsumerStatefulWidget {

  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                    newPage(context, Language(refresh: () {refresh();},));
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Design'],
                  onPressed: () {
                    newPage(context, const Design());
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Imprint'],
                  onPressed: () async {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}