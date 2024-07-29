// author Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/authentication/reset_password_page.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/login_register_switch_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/third_party_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/divider_with_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

import '../../widgets/header/header.dart';

class Login extends ConsumerWidget {

  final Function switchPages;

  Login({super.key, required this.switchPages});

  // Controllers
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  // Focus nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Text field keys
  final GlobalKey<CustomTextFormFieldState> _emailTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> _passwordTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoadingSpin.closeLoadingSpin(context);
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
                        key: _emailTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Enter your e-mail'],
                        obscureText: false,
                        textController: _emailTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: _emailFocusNode,
                        nextFocusNode: _passwordFocusNode,
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
                            key: _passwordTextFieldKey,
                            hintText: AppLanguage.getLanguageData()['Enter your password'],
                            obscureText: true,
                            textController: _passwordTextController,
                            readOnly: false,
                            autoFocus: false,
                            width: ScreenSize.screenWidth * 0.85,
                            height: ScreenSize.screenHeight * 0.065,
                            currentFocusNode: _passwordFocusNode,
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
                              newPage(context, const ResetPassword());
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
                              String password = _passwordTextController.text.trim();
                              String email = _emailTextController.text.trim();
                              bool passwordResponse = _passwordTextFieldKey.currentState!.resetsErrors();
                              bool emailResponse = _emailTextFieldKey.currentState!.resetsErrors();
                              if (passwordResponse || emailResponse) {
                                await Future.delayed(const Duration(milliseconds: 400));
                              }
                              bool emptyField = false;
                              if (email.isEmpty) {
                                _emailTextFieldKey.currentState?.showError(
                                    AppLanguage.getLanguageData()['Field is empty']);
                                emptyField = true;
                              }
                              if (password.isEmpty) {
                                _passwordTextFieldKey.currentState?.showError(
                                    AppLanguage.getLanguageData()['Field is empty']);
                                emptyField = true;
                              }
                              if (emptyField) {
                                return;
                              }
                              await authApi.emailPasswordLogin(
                                email,
                                password,
                                context,
                                _emailTextFieldKey,
                                _passwordTextFieldKey,
                              );
                              await userStateNotifier.checkUserStatus();
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
                            onTap: () async {
                              await authApi.guestLogin(context);
                              await userStateNotifier.checkUserStatus();
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: ScreenSize.screenHeight * 0.04),
                      SizedBox(
                        width: ScreenSize.screenWidth * 0.85,
                        child:DividerWithText(
                          text: AppLanguage.getLanguageData()['OR CONTINUE WITH'],
                        ),
                      ),

                      // Third party buttons
                      SizedBox(height: ScreenSize.screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ThirdPartyButton(
                            imageName: 'Google',
                            onPressed: () async {
                              await authApi.googleLogin(context);
                              await userStateNotifier.checkUserStatus();
                            },
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
