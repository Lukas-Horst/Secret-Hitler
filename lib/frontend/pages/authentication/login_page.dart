// author Lukas Horst

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
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

            // E-Mail text field
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
              hintText: AppLanguage.getLanguageData()['Enter your e-mail'],
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

            // Password text field and forgot password button
            Text(
              AppLanguage.getLanguageData()['Password'] + ':',
              style: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: Colors.white,
                fontSize: ScreenSize.screenHeight * 0.025 +
                    ScreenSize.screenWidth * 0.025,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextFormField(
                  hintText: AppLanguage.getLanguageData()['Enter your password'],
                  obscureText: true,
                  textController: passwordTextController,
                  readOnly: false,
                  autoFocus: false,
                  width: ScreenSize.screenWidth * 0.85,
                  height: ScreenSize.screenHeight * 0.065,
                  currentFocusNode: passwordFocusNode,
                ),
                CustomTextButton(
                  text: AppLanguage.getLanguageData()['Forgot password?'],
                  textStyle: TextStyle(
                      fontFamily: 'EskapadeFrakturW04BlackFamily',
                      color: AppDesign.getContraryPrimaryColor(),
                      fontSize: ScreenSize.screenHeight * 0.015 +
                          ScreenSize.screenWidth * 0.015,
                      decoration: TextDecoration.underline
                  ),
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.04),

            // Login Button and guest button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                ),
                CustomTextButton(
                  text: AppLanguage.getLanguageData()['Continue as guest'],
                  textStyle: TextStyle(
                      fontFamily: 'EskapadeFrakturW04BlackFamily',
                      color: AppDesign.getContraryPrimaryColor(),
                      fontSize: ScreenSize.screenHeight * 0.015 +
                          ScreenSize.screenWidth * 0.015,
                      decoration: TextDecoration.underline
                  ),
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: ScreenSize.screenHeight * 0.04),
            SizedBox(
              width: ScreenSize.screenWidth * 0.85,
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 3,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth * 0.02),
                    child: Text(
                      AppLanguage.getLanguageData()['OR CONTINUE WITH'],
                      style: TextStyle(
                        fontFamily: 'EskapadeFrakturW04BlackFamily',
                        fontSize: ScreenSize.screenHeight * 0.02 +
                            ScreenSize.screenWidth * 0.02,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 3,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
