// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Register extends StatefulWidget {

  final Function switchPages;

  const Register({super.key, required this.switchPages});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Header(headerText: AppLanguage.getLanguageData()['Register']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // E-Mail text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['E-Mail'],
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

                      // Password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Password'],
                      ),
                      CustomTextFormField(
                        hintText: AppLanguage.getLanguageData()['Enter your password'],
                        obscureText: true,
                        textController: passwordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: passwordFocusNode,
                        nextFocusNode: confirmPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // Confirm Password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Confirm password'],
                      ),
                      CustomTextFormField(
                        hintText: AppLanguage.getLanguageData()['Confirm your password'],
                        obscureText: true,
                        textController: confirmPasswordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: confirmPasswordFocusNode
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.04),

                      // Register button
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Register'],
                        onPressed: () {},
                      ),

                      // Link to login page
                      SizedBox(height: ScreenSize.screenHeight * 0.14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Transform.rotate(
                            angle: 330 * 3.1415926535 / 180,
                            child: Image.asset(
                              'assets/images/fascist_circle.png',
                              height: ScreenSize.screenHeight * 0.075,
                              width: ScreenSize.screenHeight * 0.07,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                AppLanguage.getLanguageData()['Already have an account?'],
                                style: TextStyle(
                                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                                  fontSize: ScreenSize.screenHeight * 0.017 +
                                      ScreenSize.screenWidth * 0.017,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight * 0.005),
                              CustomTextButton(
                                text: AppLanguage.getLanguageData()['Login'],
                                textStyle: TextStyle(
                                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                                  fontSize: ScreenSize.screenHeight * 0.017 +
                                      ScreenSize.screenWidth * 0.017,
                                  color: AppDesign.getContraryPrimaryColor(),
                                  decoration: TextDecoration.underline,
                                ),
                                onTap: () {widget.switchPages();},
                              ),
                            ],
                          ),
                          Transform.rotate(
                            angle: -330 * 3.1415926535 / 180,
                            child: Image.asset(
                              'assets/images/${AppDesign.getCirclePNG()}.png',
                              height: ScreenSize.screenHeight * 0.075,
                              width: ScreenSize.screenHeight * 0.07,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.01),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
