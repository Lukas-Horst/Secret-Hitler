// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/authentication/riverpod/provider.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class ConfirmEmail extends ConsumerStatefulWidget {
  const ConfirmEmail({super.key});

  @override
  ConsumerState<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends ConsumerState<ConfirmEmail> {

  // Controller
  final emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    final userStateNotifier = ref.watch(userStateProvider.notifier);
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
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
                onPressed: () async {},
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              SizedBox(
                width: ScreenSize.screenWidth * 0.85,
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth * 0.02),
                      child: Text(
                        AppLanguage.getLanguageData()['OR'],
                        style: TextStyle(
                          fontFamily: 'EskapadeFrakturW04BlackFamily',
                          fontSize: ScreenSize.screenHeight * 0.02 +
                              ScreenSize.screenWidth * 0.02,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
