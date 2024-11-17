// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {

  // Controllers
  final emailTextController = TextEditingController();

  // Focus nodes
  final emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    final authApi = ref.read(authApiProvider);
    final sendMailTimeout = ref.read(sendMailTimeoutProvider);

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
                      onPressed: () async {
                        String email = emailTextController.text.trim();
                        if (sendMailTimeout.isActivated) {
                          CustomSnackbar.showSnackbar(
                            '${AppLanguage.getLanguageData()['Email already sent']}\n'
                                '${AppLanguage.getLanguageData()['Please wait']} '
                                '${sendMailTimeout.timeout} '
                                '${AppLanguage.getLanguageData()[sendMailTimeout.timeout == 1 ? 'Minute' : 'Minutes'].toString().replaceAll('M', 'm')}.',
                            Colors.red,
                            const Duration(seconds: 3),
                          );
                        } else {
                          bool response = await authApi.sendRecoveryMail(email);
                          if (response) {
                            sendMailTimeout.activateTimeout();
                            CustomSnackbar.showSnackbar(
                              AppLanguage.getLanguageData()['Recovery email sent'],
                              Colors.green,
                              const Duration(seconds: 3),
                            );
                          } else {
                            CustomSnackbar.showSnackbar(
                              AppLanguage.getLanguageData()['Recovery email could not be sent'],
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
