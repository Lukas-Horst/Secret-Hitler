// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/confirm_email_page.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';

// Switch between the confirm email page and the homepage
class ConfirmEmailHomeSwitch extends ConsumerWidget {
  const ConfirmEmailHomeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
    final timer = ref.watch(timerProvider);
    // Start the timer for the user activity updates
    userStateNotifier.subscribeUserUpdates();
    timer.startTimer(
      const Duration(minutes: 5),
      () {updateOnlineStatus(ref, true);},
      null,
    );
    if (userState.user!.emailVerification || userState.withoutVerification
        || userState.isGuest) {
      userStateNotifier.unsubscribeUserUpdates();
      return const PageNavigation();
    } else {
      return const ConfirmEmail();
    }
  }
}
