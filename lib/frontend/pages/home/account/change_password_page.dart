// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/authentication/reset_password_page.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {

  // Text field keys
  final GlobalKey<CustomTextFormFieldState> oldPasswordTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> newPasswordTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> confirmNewPasswordTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  // Controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Focus nodes
  final oldPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmNewPasswordFocusNode = FocusNode();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authApi = ref.read(authApiProvider);
    final userState = ref.read(userStateProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {
          _goBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            children: [
              Header(headerText: AppLanguage.getLanguageData()['Change password']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Old password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Old password'],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextFormField(
                            key: oldPasswordTextFieldKey,
                            hintText: AppLanguage.getLanguageData()['Enter your old password'],
                            obscureText: true,
                            textController: oldPasswordController,
                            readOnly: false,
                            autoFocus: false,
                            width: ScreenSize.screenWidth * 0.85,
                            height: ScreenSize.screenHeight * 0.065,
                            currentFocusNode: oldPasswordFocusNode,
                            nextFocusNode: newPasswordFocusNode,
                          ),
                          CustomTextButton(
                            text: AppLanguage.getLanguageData()['Forgot password?'],
                            textStyle: TextStyle(
                              fontFamily: 'EskapadeFrakturW04BlackFamily',
                              color: AppDesign.getContraryPrimaryColor(),
                              fontSize: ScreenSize.screenHeight * 0.015 +
                                  ScreenSize.screenWidth * 0.015,
                              decoration: TextDecoration.underline,
                            ),
                            onTap: () {
                              replacePage(context, ResetPassword(email: userState.user!.email,));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // New password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['New password'],
                      ),
                      CustomTextFormField(
                        key: newPasswordTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Enter your new password'],
                        obscureText: true,
                        textController: newPasswordController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: newPasswordFocusNode,
                        nextFocusNode: confirmNewPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // Confirm new password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Confirm password'],
                      ),
                      CustomTextFormField(
                        key: confirmNewPasswordTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Confirm your password'],
                        obscureText: true,
                        textController: confirmNewPasswordController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: confirmNewPasswordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.08),

                      // Save button
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Save'],
                        onPressed: () async {
                          String oldPassword = oldPasswordController.text.trim();
                          String newPassword = newPasswordController.text.trim();
                          String confirmNewPassword = confirmNewPasswordController.text.trim();
                          confirmNewPasswordTextFieldKey.currentState?.resetsErrors();
                          bool oldPasswordResponse = oldPasswordTextFieldKey.currentState!.resetsErrors();
                          bool newPasswordResponse = newPasswordTextFieldKey.currentState!.resetsErrors();
                          if (oldPasswordResponse || newPasswordResponse) {
                            await Future.delayed(const Duration(milliseconds: 400));
                          }
                          if (oldPassword.isEmpty) {
                            oldPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Field is empty']);
                          } else if (newPassword.length < 8) {
                            newPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Less than 8 characters']);
                            confirmNewPasswordTextFieldKey.currentState?.showError('');
                          } else if (newPassword.length > 256) {
                            newPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['More than 256 characters']);
                            confirmNewPasswordTextFieldKey.currentState?.showError('');
                          } else if (newPassword != confirmNewPassword) {
                            confirmNewPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Passwords do not match']);
                            newPasswordTextFieldKey.currentState?.showError('');
                          } else if (newPassword == oldPassword) {
                            newPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['No changes to the old password']);
                            confirmNewPasswordTextFieldKey.currentState?.showError('');
                          } else {
                            bool response = await authApi.changePassword(
                              newPassword, oldPassword,
                              oldPasswordTextFieldKey, context);
                            if (response) {
                              CustomSnackbar.showSnackbar(
                                AppLanguage.getLanguageData()['Your password has been changed'],
                                Colors.green,
                                const Duration(seconds: 3),
                              );
                            } else {
                              CustomSnackbar.showSnackbar(
                                AppLanguage.getLanguageData()['Your password could not be changed'],
                                Colors.red,
                                const Duration(seconds: 3),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavigationBackButton(onPressed: () {
              _goBack(context);
            }),
          ],
        ),
      ),
    );
  }
}
