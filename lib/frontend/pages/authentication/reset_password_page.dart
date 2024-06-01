// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/authentication/new_password_page.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  // Controllers
  final emailTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(headerText: AppLanguage.getLanguageData()['Reset password']),
            SizedBox(height: ScreenSize.screenHeight * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ExplainingText(
                      text: AppLanguage.getLanguageData()['Enter your e-mail to reset your password.'],
                    ),
                    SizedBox(height: ScreenSize.screenHeight * 0.04),
                    TextFieldHeadText(
                      text: AppLanguage.getLanguageData()['E-Mail'],
                    ),
                    CustomTextFormField(
                      hintText: AppLanguage.getLanguageData()['Enter your e-mail'],
                      obscureText: false,
                      textController: emailTextController,
                      readOnly: false,
                      autoFocus: true,
                      width: ScreenSize.screenWidth * 0.85,
                      height: ScreenSize.screenHeight * 0.065,
                      currentFocusNode: emailFocusNode,
                    ),

                    SizedBox(height: ScreenSize.screenHeight * 0.04),
                    PrimaryElevatedButton(
                      text: AppLanguage.getLanguageData()['Continue'],
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationBackButton(onPressed: () {Navigator.pop(context);}),
        ],
      ),
    );
  }
}
