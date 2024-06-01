// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/scroll_wheel.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class NewGame extends StatefulWidget {

  final int? scrollWheelStartNumber;

  const NewGame({super.key, this.scrollWheelStartNumber,});

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {

  // Controllers
  final roomNameTextController = TextEditingController();
  final roomPasswordTextController = TextEditingController();
  late FixedExtentScrollController scrollWheelController;

  // Focus nodes
  final roomNameFocusNode = FocusNode();
  final roomPasswordFocusNode = FocusNode();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    late int controllerInitialItem;

    if (widget.scrollWheelStartNumber != null) {
      controllerInitialItem = widget.scrollWheelStartNumber! - 5;
    } else {
      controllerInitialItem = 0;
    }
    scrollWheelController = FixedExtentScrollController(
      initialItem: controllerInitialItem,
    );
    super.initState();
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
              Header(headerText: AppLanguage.getLanguageData()['New Game']),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenSize.screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AdjustableStandardText(
                            text: '${AppLanguage.getLanguageData()['Number of players']}:',
                            color: Colors.white,
                            size: ScreenSize.screenHeight * 0.02 +
                                ScreenSize.screenWidth * 0.02,
                          ),
                          SizedBox(width: ScreenSize.screenWidth * 0.1,),
                          Container(
                            height: ScreenSize.screenHeight * 0.12,
                            width: ScreenSize.screenWidth * 0.15,
                            decoration: BoxDecoration(
                              color: AppDesign.getPrimaryColor(),
                              border: Border.all(
                                color: Colors.black,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: ScrollWheel(
                              firstNumber: 5,
                              lastNumber: 10,
                              itemExtent: ScreenSize.screenHeight * 0.05,
                              scrollController: scrollWheelController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.02),
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
                        text: AppLanguage.getLanguageData()['Continue'],
                        onPressed: () {},
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.01),
                    ],
                  ),
                ),
              ),
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
