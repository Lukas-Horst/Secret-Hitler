// author Lukas Horst

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';

import '../../widgets/header/header.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            Header(headerText: AppLanguage.getLanguageData()['Login']),
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            Text(
              AppLanguage.getLanguageData()['E-Mail'] + ':',
              style: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: Colors.white,
                fontSize: ScreenSize.screenHeight * 0.025 +
                    ScreenSize.screenWidth * 0.025,
              ),
            ),
            CustomTextFormField(
              hintText: AppLanguage.getLanguageData()['E-Mail'],
              obscureText: false,
              textController: emailTextController,
              readOnly: false,
              autoFocus: false,
              width: ScreenSize.screenWidth * 0.85,
              height: ScreenSize.screenHeight * 0.065,
              currentFocusNode: emailFocusNode,
              nextFocusNode: passwordFocusNode,
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            Text(
              AppLanguage.getLanguageData()['Password'] + ':',
              style: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: Colors.white,
                fontSize: ScreenSize.screenHeight * 0.025 +
                    ScreenSize.screenWidth * 0.025,
              ),
            ),
            CustomTextFormField(
              hintText: AppLanguage.getLanguageData()['Password'],
              obscureText: true,
              textController: passwordTextController,
              readOnly: false,
              autoFocus: false,
              width: ScreenSize.screenWidth * 0.85,
              height: ScreenSize.screenHeight * 0.065,
              currentFocusNode: passwordFocusNode,
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesign.getSecondaryColor(),
                foregroundColor: Colors.black,
                fixedSize: Size(
                    ScreenSize.screenWidth * 0.85,
                    ScreenSize.screenHeight * 0.065,
                ),
                side: const BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                )
              ),
              child: Text(
                AppLanguage.getLanguageData()['Login'],
                style: TextStyle(
                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                  fontSize: ScreenSize.screenHeight * 0.025 +
                      ScreenSize.screenWidth * 0.025,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
