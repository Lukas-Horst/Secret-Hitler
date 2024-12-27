// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/divider_with_text.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

class ConfirmEmail extends ConsumerStatefulWidget {
  const ConfirmEmail({super.key});

  @override
  ConsumerState<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends ConsumerState<ConfirmEmail> {

  // Controller
  final emailTextController = TextEditingController();
  bool _emailSent = false;

  @override
  Widget build(BuildContext context) {
    final authApi = ref.watch(authApiProvider);
    final userState = ref.watch(userStateProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
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
              Header(headerText: AppLanguage.getLanguageData()['Confirm E-Mail']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Confirm your current email'],
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              CustomTextFormField(
                hintText: userState.user!.email,
                obscureText: false,
                textController: emailTextController,
                readOnly: true,
                autoFocus: false,
                width: ScreenSize.screenWidth * 0.85,
                height: ScreenSize.screenHeight * 0.065,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.08),
              PrimaryElevatedButton(
                text: AppLanguage.getLanguageData()['Send confirmation e-mail'],
                textSize: ScreenSize.screenHeight * 0.0175 +
                    ScreenSize.screenWidth * 0.0175,
                onPressed: () async {
                  if (!_emailSent) {
                    bool response = await authApi.sendVerificationMail(context);
                    if (response) {
                      _emailSent = true;
                      CustomSnackbar.showSnackbar(
                        AppLanguage.getLanguageData()['Confirmation email sent'],
                        Colors.green,
                        const Duration(seconds: 3),
                      );
                    } else {
                      CustomSnackbar.showSnackbar(
                        AppLanguage.getLanguageData()['Confirmation email could not be sent'],
                        Colors.red,
                        const Duration(seconds: 3),
                      );
                    }
                  } else {
                    CustomSnackbar.showSnackbar(
                      AppLanguage.getLanguageData()['Email already sent'],
                      Colors.green,
                      const Duration(seconds: 3),
                    );
                  }
                },
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              SizedBox(
                width: ScreenSize.screenWidth * 0.85,
                child: DividerWithText(
                  text: AppLanguage.getLanguageData()['OR'],
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              PrimaryElevatedButton(
                text: AppLanguage.getLanguageData()['Continue without confirmation'],
                textSize: ScreenSize.screenHeight * 0.0175 +
                    ScreenSize.screenWidth * 0.0175,
                onPressed: () async {
                  await userStateNotifier.changeVerificationState();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
