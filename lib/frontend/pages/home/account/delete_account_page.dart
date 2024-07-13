// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  // Controllers
  final deleteAccountTextController = TextEditingController();

  // Focus nodes
  final deleteAccountFocusNode = FocusNode();

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
              Header(headerText: AppLanguage.getLanguageData()['Delete account']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Please enter "DELETE"'],
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),

              // Delete text field
              CustomTextFormField(
                hintText: AppLanguage.getLanguageData()['Enter "DELETE"'],
                obscureText: false,
                textController: deleteAccountTextController,
                readOnly: false,
                autoFocus: false,
                width: ScreenSize.screenWidth * 0.85,
                height: ScreenSize.screenHeight * 0.065,
                currentFocusNode: deleteAccountFocusNode,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),

              // Delete button
              PrimaryElevatedButton(
                text: AppLanguage.getLanguageData()['Delete'],
                onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
