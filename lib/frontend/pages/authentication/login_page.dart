// author Lukas Horst

import 'package:flutter/material.dart';

import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/authentication/reset_password_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';

import '../../widgets/header/header.dart';

class Login extends StatefulWidget {

  final Function switchPages;

  const Login({super.key, required this.switchPages});

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
                            
                    // Password text field and forgot password button
                    TextFieldHeadText(
                      text: AppLanguage.getLanguageData()['Password'],
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPassword()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.screenHeight * 0.04),
                            
                    // Login Button and guest button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PrimaryElevatedButton(
                          text: AppLanguage.getLanguageData()['Login'],
                          onPressed: () {},
                        ),
                        CustomTextButton(
                          text: AppLanguage.getLanguageData()['Continue as guest'],
                          textStyle: TextStyle(
                              fontFamily: 'EskapadeFrakturW04BlackFamily',
                              color: AppDesign.getContraryPrimaryColor(),
                              fontSize: ScreenSize.screenHeight * 0.015 +
                                  ScreenSize.screenWidth * 0.015,
                              decoration: TextDecoration.underline,
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

                    // Third party buttons
                    SizedBox(height: ScreenSize.screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/Google.png',
                          ),
                          style: IconButton.styleFrom(
                              backgroundColor: AppDesign.getSecondaryColor(),
                              foregroundColor: Colors.black,
                              fixedSize: Size(
                                ScreenSize.screenWidth * 0.2125,
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
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/Apple.png',
                          ),
                          style: IconButton.styleFrom(
                              backgroundColor: AppDesign.getSecondaryColor(),
                              foregroundColor: Colors.black,
                              fixedSize: Size(
                                ScreenSize.screenWidth * 0.2125,
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
                        ),
                      ],
                    ),

                    // Link to register page
                    SizedBox(height: ScreenSize.screenHeight * 0.04),
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
                              AppLanguage.getLanguageData()['No Account yet?'],
                              style: TextStyle(
                                fontFamily: 'EskapadeFrakturW04BlackFamily',
                                fontSize: ScreenSize.screenHeight * 0.017 +
                                    ScreenSize.screenWidth * 0.017,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: ScreenSize.screenHeight * 0.005),
                            CustomTextButton(
                              text: AppLanguage.getLanguageData()['Register'],
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
    );
  }
}
