// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Register extends ConsumerWidget {

  final Function switchPages;

  Register({super.key, required this.switchPages});

  // Controllers
  final emailTextController = TextEditingController();

  final passwordTextController = TextEditingController();

  final confirmPasswordTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authApi = ref.watch(authApiProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
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
                        currentFocusNode: confirmPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.06),

                      // Register button
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Register'],
                        onPressed: () async {
                          try {
                            final response = await authApi.signIn(
                              emailTextController.text.trim(),
                              passwordTextController.text.trim(),
                              context,
                              ref,
                            );
                            // If the sign in was successful the user will be logged in
                            if (response) {
                              await authApi.emailPasswordLogin(
                                emailTextController.text.trim(),
                                passwordTextController.text.trim(),
                                context,
                                ref,
                              );
                              userStateNotifier.checkUserStatus();
                            }
                          } catch(e) {
                            print(e);
                          }
                        },
                      ),

                      // Link to login page
                      SizedBox(height: ScreenSize.screenHeight * 0.12),
                      LoginRegisterSwitchButton(
                        questionText: AppLanguage.getLanguageData()['Already have an account?'],
                        buttonText: AppLanguage.getLanguageData()['Login'],
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
