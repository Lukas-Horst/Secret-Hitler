// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/authentication/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/account/user_data_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Account extends ConsumerWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authApi = ref.watch(authApiProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Header(headerText: 'Account'),
          SizedBox(height: ScreenSize.screenHeight * 0.08),
          // Buttons
          SizedBox(
            height: ScreenSize.screenHeight * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['User data'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserData()),
                    );
                  },
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Statistics'],
                  onPressed: () {},
                ),
                PrimaryElevatedButton(
                  text: AppLanguage.getLanguageData()['Logout'],
                  onPressed: () async {
                    try {
                      await authApi.logout();
                      userNotifier.checkUserStatus();
                    } catch(e) {
                      print(e);
                    }
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