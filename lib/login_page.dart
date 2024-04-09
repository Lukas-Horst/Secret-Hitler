// author Lukas Horst

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:secret_hitler/app_language/app_language.dart';
import 'package:secret_hitler/widgets/header.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF474747),
      body: SafeArea(
        child: Row(
          children: [
            Header(headerText: AppLanguage.getLanguageData()['login'],
                headerImage: 'Liberal_3', headerColor: Color(0xFF479492)),
          ],
        ),
      ),
    );
  }
}
