// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/account/change_password_page.dart';
import 'package:secret_hitler/frontend/pages/home/account/delete_account_page.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {

  // Controllers
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();

  // Focus nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context);
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
                        hintText: AppLanguage.getLanguageData()['Enter your name'],
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
                        hintText: AppLanguage.getLanguageData()['Enter your e-mail'],
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ChangePassword()),
                              );
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
              _goBack(context);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteAccount()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
