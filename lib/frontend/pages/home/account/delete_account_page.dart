// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({super.key});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {

  // Controllers
  final deleteAccountTextController = TextEditingController();

  // Focus nodes
  final deleteAccountFocusNode = FocusNode();

  // Text field keys
  final GlobalKey<CustomTextFormFieldState> deleteAccountTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.read(userStateProvider);
    final authApi = ref.read(authApiProvider);
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
              Header(headerText: AppLanguage.getLanguageData()['Delete account']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Please enter "DELETE"'],
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),

              // Delete text field
              CustomTextFormField(
                key: deleteAccountTextFieldKey,
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
                onPressed: () async {
                  String userInput = deleteAccountTextController.text.trim();
                  if (userInput == '') {
                    deleteAccountTextFieldKey.currentState?.resetsErrors();
                    // LoadingSpin.openLoadingSpin(context);
                    bool response = await deleteUser(
                      userState.user!.$id,
                      authApi.getClient(),
                    );
                    if (!response) {
                      CustomSnackbar.showSnackbar(
                        AppLanguage.getLanguageData()['There was an error. Please try again!'],
                        Colors.red,
                        const Duration(seconds: 3),
                      );
                    }
                  } else {
                    deleteAccountTextFieldKey.currentState?.showError(
                        AppLanguage.getLanguageData()['Enter "DELETE"'],
                    );
                  }
                },
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
