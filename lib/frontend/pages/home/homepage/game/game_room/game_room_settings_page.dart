// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_naviagtion.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';

class GameRoomSettings extends ConsumerWidget {

  const GameRoomSettings({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final gameStatNotifier = ref.read(gameStateProvider.notifier);
            gameStatNotifier.unsubscribeGameRoom();
            closePage(context, 1);
          },
        )
      ],
    );
  }
}
