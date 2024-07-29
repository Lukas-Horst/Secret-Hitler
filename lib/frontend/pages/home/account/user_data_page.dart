// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/authentication/user_state_notifier.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/account/change_password_page.dart';
import 'package:secret_hitler/frontend/pages/home/account/delete_account_page.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/custom_text_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class UserData extends ConsumerStatefulWidget {
  const UserData({super.key});

  @override
  ConsumerState<UserData> createState() => _UserDataState();
}

class _UserDataState extends ConsumerState<UserData> {

  // Controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();

  // Focus nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  void _goBack(BuildContext context, UserStateNotifier userStateNotifier) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authApi = ref.watch(authApiProvider);
    final userState = ref.watch(userStateProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context, userStateNotifier);
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
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.10),

                      // Save button and change password button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PrimaryElevatedButton(
                            text: AppLanguage.getLanguageData()['Save'],
                            onPressed: () {},
                          ),
                          CustomTextButton(
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
                          ),
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
              _goBack(context, userStateNotifier);
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
