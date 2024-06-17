// author Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/authentication/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/authentication/reset_password_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';

import '../../widgets/header/header.dart';

class Login extends ConsumerWidget {

  final Function switchPages;

  Login({super.key, required this.switchPages});

  // Controllers
  final emailTextController = TextEditingController();

  final passwordTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authApi = ref.watch(authApiProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {}
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                            onPressed: () async {
                              try {
                                await authApi.emailPasswordLogin(
                                  emailTextController.text,
                                  passwordTextController.text,
                                );
                                userNotifier.checkUserStatus();
                              } catch(e) {
                                print(e);
                              }
                            },
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
                          ThirdPartyButton(
                            imageName: 'Google',
                            onPressed: () {},
                          ),
                          ThirdPartyButton(
                            imageName: 'Apple',
                            onPressed: () {},
                          ),
                        ],
                      ),

                      // Link to register page
                      SizedBox(height: ScreenSize.screenHeight * 0.04),
                      LoginRegisterSwitchButton(
                        questionText: AppLanguage.getLanguageData()['No Account yet?'],
                        buttonText: AppLanguage.getLanguageData()['Register'],
                        onTap: () {switchPages();},
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
