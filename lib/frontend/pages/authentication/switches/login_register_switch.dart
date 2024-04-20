// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/frontend/pages/authentication/login_page.dart';
import 'package:secret_hitler/frontend/pages/authentication/register_page.dart';

class LoginRegisterSwitch extends StatefulWidget {
  const LoginRegisterSwitch({super.key});

  @override
  State<LoginRegisterSwitch> createState() => _LoginRegisterSwitchState();
}

class _LoginRegisterSwitchState extends State<LoginRegisterSwitch> {
  // initially, show the login page
  bool _showLoginPage = true;

  // switch between login and register page
  void switchPages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return Login(switchPages: switchPages);
    } else {
      return Register(switchPages: switchPages);
    }
  }
}
