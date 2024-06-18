// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/login_register_switch.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';


class LoginHomeSwitch extends ConsumerWidget {
  const LoginHomeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    bool firstPageCall = true;
    if (user == null) {
      return const LoginRegisterSwitch();
    } else {
      return const PageNavigation();
    }
  }
}
