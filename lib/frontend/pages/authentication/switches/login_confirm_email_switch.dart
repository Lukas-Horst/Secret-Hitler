// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/confirm_email_home_switch.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/loading_page.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/login_register_switch.dart';

// Switch between the login page and the confirm email page
class LoginConfirmEmailSwitch extends ConsumerWidget {
  const LoginConfirmEmailSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    final timer = ref.watch(timerProvider);
    if (userState.user == null) {
      if (userState.firstCheck) {
        // Stop the timer for the user activity updates
        timer.stopTimer();
        return const LoginRegisterSwitch();
      } else {
        return const LoadingPage();
      }
    } else {
      return const ConfirmEmailHomeSwitch();
    }
  }
}
