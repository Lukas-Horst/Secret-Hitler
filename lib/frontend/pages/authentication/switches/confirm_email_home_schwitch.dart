// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/confirm_email_page.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';

// Switch between the confirm email page and the homepage
class ConfirmEmailHomeSwitch extends ConsumerWidget {
  const ConfirmEmailHomeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    if (userState.user!.emailVerification || userState.withoutVerification) {
      return const PageNavigation();
    } else {
      return const ConfirmEmail();
    }
  }
}
