// author Lukas Horst

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';

import '../../widgets/header/header.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      body: SafeArea(
        child: Row(
          children: [
            Header(headerText: AppLanguage.getLanguageData()['login']),
          ],
        ),
      ),
    );
  }
}
