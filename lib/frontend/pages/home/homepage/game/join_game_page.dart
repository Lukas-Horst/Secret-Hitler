// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {

  // Controllers
  final roomNameTextController = TextEditingController();
  final roomPasswordTextController = TextEditingController();

  // Focus nodes
  final roomNameFocusNode = FocusNode();
  final roomPasswordFocusNode = FocusNode();

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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              Header(headerText: AppLanguage.getLanguageData()['Join Game']),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenSize.screenHeight * 0.04),
                      // Room name text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Room name'],
                      ),
                      CustomTextFormField(
                        hintText: AppLanguage.getLanguageData()['Enter the room name'],
                        obscureText: false,
                        textController: roomNameTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: roomNameFocusNode,
                        nextFocusNode: roomPasswordFocusNode,
                      ),

                      SizedBox(height: ScreenSize.screenHeight * 0.02),
                      // Room password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Room password'],
                      ),
                      CustomTextFormField(
                        hintText: AppLanguage.getLanguageData()['Enter the room password'],
                        obscureText: true,
                        textController: roomPasswordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: roomPasswordFocusNode,
                      ),

                      SizedBox(height: ScreenSize.screenHeight * 0.06),
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Join'],
                        onPressed: () {},
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.01),
                    ],
                  ),
                ),
              )
            ],
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
      ),
    );
  }
}
