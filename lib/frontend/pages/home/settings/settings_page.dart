// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/authentication_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/settings/design_page.dart';
import 'package:secret_hitler/frontend/pages/home/settings/language_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
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
    final databaseApi = ref.watch(databaseApiProvider);
    final userState = ref.watch(userStateProvider);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Language(refresh: () {refresh();},)),
                    );
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Design'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Design()),
                    );
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Imprint'],
                  onPressed: () async {
                    bool response = await changeOnlineStatus(ref, true);
                    print(response);
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