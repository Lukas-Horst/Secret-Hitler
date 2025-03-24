// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/loading_spin.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {

  // Controllers
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Focus nodes
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    LoadingSpin.closeLoadingSpin(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {}
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(headerText: AppLanguage.getLanguageData()['New password']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Enter your new password'] + '.',
              ),

              SizedBox(height: ScreenSize.screenHeight * 0.04),
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
              SizedBox(height: ScreenSize.screenHeight * 0.04),

              // Register button
              PrimaryElevatedButton(
                text: AppLanguage.getLanguageData()['Register'],
                onPressed: () {},
              ),

              SizedBox(height: ScreenSize.screenHeight * 0.2),
              SizedBox(
                width: ScreenSize.screenWidth * 0.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.rotate(
                      angle: 330 * 3.1415926535 / 180,
                      child: Image.asset(
                        'assets/images/fascist_circle.png',
                        height: ScreenSize.screenHeight * 0.075,
                        width: ScreenSize.screenHeight * 0.07,
                      ),
                    ),
                    Transform.rotate(
                      angle: -330 * 3.1415926535 / 180,
                      child: Image.asset(
                        'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
                        height: ScreenSize.screenHeight * 0.075,
                        width: ScreenSize.screenHeight * 0.07,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
