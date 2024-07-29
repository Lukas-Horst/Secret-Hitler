// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/login_register_switch_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Register extends ConsumerWidget {

  final Function switchPages;

  Register({super.key, required this.switchPages});

  // Controllers
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  // Focus nodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // Text field keys
  final GlobalKey<CustomTextFormFieldState> _emailTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> _passwordTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> _confirmPasswordTextFieldKey = GlobalKey<CustomTextFormFieldState>();

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

                      // Password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Password'],
                      ),
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
                        nextFocusNode: _confirmPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // Confirm Password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Confirm password'],
                      ),
                      CustomTextFormField(
                        key: _confirmPasswordTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Confirm your password'],
                        obscureText: true,
                        textController: _confirmPasswordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: _confirmPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.06),

                      // Register button
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Register'],
                        onPressed: () async {
                          String password = _passwordTextController.text.trim();
                          String confirmedPassword = _confirmPasswordTextController.text.trim();
                          String email = _emailTextController.text.trim();
                          _confirmPasswordTextFieldKey.currentState?.resetsErrors();
                          bool passwordResponse = _passwordTextFieldKey.currentState!.resetsErrors();
                          bool emailResponse = _emailTextFieldKey.currentState!.resetsErrors();
                          if (passwordResponse || emailResponse) {
                            await Future.delayed(const Duration(milliseconds: 400));
                          }
                          if (email.isEmpty) {
                            _emailTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Field is empty']);
                          } else if (password.length < 8) {
                            _passwordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Less than 8 characters']);
                            _confirmPasswordTextFieldKey.currentState?.showError('');
                          } else if (password.length > 256) {
                            _passwordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['More than 256 characters']);
                            _confirmPasswordTextFieldKey.currentState?.showError('');
                          } else if (password != confirmedPassword) {
                            _confirmPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Passwords do not match']);
                            _passwordTextFieldKey.currentState?.showError('');
                          } else {
                            try {
                              final response = await authApi.signIn(
                                email,
                                password,
                                context,
                                _emailTextFieldKey,
                                _passwordTextFieldKey,
                                _confirmPasswordTextFieldKey,
                              );
                              // If the sign in was successful the user will be logged in
                              if (response) {
                                await authApi.emailPasswordLogin(
                                  _emailTextController.text.trim(),
                                  _passwordTextController.text.trim(),
                                  context,
                                  _emailTextFieldKey,
                                  _passwordTextFieldKey,
                                );
                                await userStateNotifier.checkUserStatus();
                                await createUser(ref);
                              }
                            } catch(e) {
                              print(e);
                            }
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
