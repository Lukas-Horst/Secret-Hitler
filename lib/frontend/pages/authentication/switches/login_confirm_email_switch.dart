// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/confirm_email_home_schwitch.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/loading_page.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/login_register_switch.dart';

// Switch between the login page and the confirm email page
class LoginConfirmEmailSwitch extends ConsumerWidget {
  const LoginConfirmEmailSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    if (userState.user == null) {
      if (userState.firstCheck) {
        return const LoginRegisterSwitch();
      } else {
        return const LoadingPage();
      }
    } else {
      return const ConfirmEmailHomeSwitch();
    }
  }
}
