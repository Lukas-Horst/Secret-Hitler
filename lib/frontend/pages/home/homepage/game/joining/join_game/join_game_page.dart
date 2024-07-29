// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/join_game/qr_code_scanner_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/join_game/search_game_room_page.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class JoinGame extends ConsumerStatefulWidget {
  const JoinGame({super.key});

  @override
  ConsumerState<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends ConsumerState<JoinGame> {

  // Controllers
  final _roomIdTextController = TextEditingController();
  final _roomPasswordTextController = TextEditingController();

  // Focus nodes
  final _roomIdFocusNode = FocusNode();
  final _roomPasswordFocusNode = FocusNode();

  final GlobalKey<CustomTextFormFieldState> _roomIdTextFieldKey = GlobalKey<CustomTextFormFieldState>();
  final GlobalKey<CustomTextFormFieldState> _roomPasswordTextFieldKey = GlobalKey<CustomTextFormFieldState>();

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
                        text: AppLanguage.getLanguageData()['Room id'],
                      ),
                      CustomTextFormField(
                        key: _roomIdTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Enter the room id'],
                        obscureText: false,
                        textController: _roomIdTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: _roomIdFocusNode,
                        nextFocusNode: _roomPasswordFocusNode,
                      ),

                      SizedBox(height: ScreenSize.screenHeight * 0.02),
                      // Room password text field
                      TextFieldHeadText(
                        text: AppLanguage.getLanguageData()['Room password'],
                      ),
                      CustomTextFormField(
                        key: _roomPasswordTextFieldKey,
                        hintText: AppLanguage.getLanguageData()['Enter the room password'],
                        obscureText: true,
                        textController: _roomPasswordTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: _roomPasswordFocusNode,
                      ),

                      SizedBox(height: ScreenSize.screenHeight * 0.06),
                      PrimaryElevatedButton(
                        text: AppLanguage.getLanguageData()['Join'],
                        onPressed: () async {
                          Document? gameRoomDocument = await getWaitingRoom(
                            ref,
                            _roomIdTextController.text.trim(),
                            context,
                          );
                          bool idResponse = _roomIdTextFieldKey.currentState!.resetsErrors();
                          bool passwordResponse = _roomPasswordTextFieldKey.currentState!.resetsErrors();
                          if (idResponse || passwordResponse) {
                            await Future.delayed(const Duration(milliseconds: 400));
                          }
                          String password = _roomPasswordTextController.text.trim();
                          if (gameRoomDocument != null) {
                            if (password == gameRoomDocument.data['password']) {
                              joinWaitingRoom(ref, gameRoomDocument, context, 0,);
                            } else {
                              _roomPasswordTextFieldKey.currentState?.showError(
                                AppLanguage.getLanguageData()['Wrong password'],);
                            }
                          } else {
                            _roomIdTextFieldKey.currentState?.showError(
                              AppLanguage.getLanguageData()['Wrong Id']);
                          }
                        },
                      ),
                      SizedBox(height: ScreenSize.screenHeight * 0.01),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavigationBackButton(onPressed: () {
                _goBack(context);
              }),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                      size: ScreenSize.screenHeight * 0.04 +
                          ScreenSize.screenWidth * 0.04,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      newPage(context, const QrCodeScannerPage());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: ScreenSize.screenHeight * 0.04 +
                          ScreenSize.screenWidth * 0.04,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      newPage(context, const SearchGameRoom());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
