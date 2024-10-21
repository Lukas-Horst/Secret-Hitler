// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/authentication/user_state_notifier.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/account/change_password_page.dart';
import 'package:secret_hitler/frontend/pages/home/account/delete_account_page.dart';
import 'package:secret_hitler/frontend/widgets/components/alert_dialog.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

class UserData extends ConsumerStatefulWidget {
  const UserData({super.key});

  @override
  ConsumerState<UserData> createState() => _UserDataState();
}

class _UserDataState extends ConsumerState<UserData> {

  // Controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Focus nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Text field keys
  final GlobalKey<CustomTextFormFieldState> passwordTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  void _goBack(BuildContext context, UserStateNotifier userStateNotifier,
      User user) {
    if (_checkChanges(user)) {
      CustomAlertDialog.showAlertDialog(
        AppLanguage.getLanguageData()['Unsaved changes'],
        AppLanguage.getLanguageData()['There are unsaved changes'],
        context,
      );
    } else {
      Navigator.pop(context);
    }
  }

  // Method to check if the user name and/or email changed
  bool _checkChanges(User user) {
    String newUserName = nameTextController.text.trim();
    String newEmail = emailTextController.text.trim();
    String oldUserName = user.name;
    String oldEmail = user.email;
    return (newUserName != oldUserName && newUserName.isNotEmpty)
        || (newEmail != oldEmail && newEmail.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
    final authApi = ref.watch(authApiProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context, userStateNotifier, userState.user!);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            children: [
              Header(headerText: AppLanguage.getLanguageData()['User data']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Name'],
                      ),
                      CustomTextFormField(
                        hintText: userState.user!.name,
                        obscureText: false,
                        textController: nameTextController,
                        readOnly: true,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: nameFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // E-Mail text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['E-Mail'],
                      ),
                      CustomTextFormField(
                        hintText: userState.user!.email,
                        obscureText: false,
                        textController: emailTextController,
                        readOnly: true,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: emailFocusNode,
                        provider: userState.provider,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),

                      // Password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Password'],
                      ),
                      CustomTextFormField(
                        key: passwordTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Enter your password'],
                        obscureText: true,
                        textController: passwordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: passwordFocusNode,
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.10),

                      // Save button and change password button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PrimaryElevatedButton(
                            text: AppLanguage.getLanguageData()['Save'],
                            onPressed: () async {
                              bool passwordResponse = passwordTextFieldKey.currentState!.resetsErrors();
                              if (passwordResponse) {
                                await Future.delayed(const Duration(milliseconds: 400));
                              }
                              if (_checkChanges(userState.user!)) {
                                String userName = nameTextController.text.trim();
                                String email = emailTextController.text.trim();
                                String password = passwordTextController.text.trim();
                                bool nameResponse = false;
                                bool emailResponse = false;
                                if (userName.isNotEmpty) {
                                  LoadingSpin.openLoadingSpin(context);
                                  nameResponse = await updateUserName(ref, userName);
                                } else {
                                  nameResponse = true;
                                }
                                if (email.isNotEmpty) {
                                  if (password.length < 8
                                      || password.length > 256) {
                                    passwordTextFieldKey.currentState?.showError(
                                        AppLanguage.getLanguageData()['Please enter your password']);
                                  } else {
                                    LoadingSpin.openLoadingSpin(context);
                                    emailResponse = await authApi.updateEmail(
                                      email,
                                      password,
                                      context,
                                      passwordTextFieldKey,
                                    );
                                  }
                                } else {
                                  emailResponse = true;
                                }
                                LoadingSpin.closeLoadingSpin(context);
                                if (nameResponse && emailResponse) {
                                  userStateNotifier.checkUserStatus();
                                  CustomSnackbar.showSnackbar(
                                    AppLanguage.getLanguageData()['Changes saved'],
                                    Colors.green,
                                    const Duration(seconds: 3),
                                  );
                                } else if (nameResponse) {
                                  CustomSnackbar.showSnackbar(
                                    AppLanguage.getLanguageData()['Email couldn\'t be saved'],
                                    Colors.red,
                                    const Duration(seconds: 3),
                                  );
                                } else {
                                  CustomSnackbar.showSnackbar(
                                    AppLanguage.getLanguageData()['Changes couldn\'t be saved. Please try again!'],
                                    Colors.red,
                                    const Duration(seconds: 3),
                                  );
                                }
                              } else {
                                CustomSnackbar.showSnackbar(
                                  AppLanguage.getLanguageData()['There are no changes'],
                                  Colors.red,
                                  const Duration(seconds: 3),
                                );
                              }
                            },
                          ),
                          userState.provider == null
                              ? CustomTextButton(
                                text: AppLanguage.getLanguageData()['Change password'] + '?',
                                textStyle: TextStyle(
                                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                                  color: AppDesign.getContraryPrimaryColor(),
                                  fontSize: ScreenSize.screenHeight * 0.015 +
                                  ScreenSize.screenWidth * 0.015,
                                  decoration: TextDecoration.underline,
                                ),
                                onTap: () {
                                  newPage(context, const ChangePassword());
                                  },
                                )
                              : const SizedBox(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavigationBackButton(onPressed: () {
              _goBack(context, userStateNotifier, userState.user!);
            }),
            SizedBox(width: ScreenSize.screenWidth * 0.19),
            CustomTextButton(
              text: AppLanguage.getLanguageData()['Delete account'] + '?',
              textStyle: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                color: AppDesign.getContraryPrimaryColor(),
                fontSize: ScreenSize.screenHeight * 0.015 +
                    ScreenSize.screenWidth * 0.015,
                decoration: TextDecoration.underline,
              ),
              onTap: () {
                newPage(context, const DeleteAccount());
              },
            ),
          ],
        ),
      ),
    );
  }
}
