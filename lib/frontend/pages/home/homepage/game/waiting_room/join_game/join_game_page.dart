// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/waiting_room/join_game/search_game_room_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/waiting_room/waiting_room_page.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text_form_field.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class JoinGame extends ConsumerStatefulWidget {
  const JoinGame({super.key});

  @override
  ConsumerState<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends ConsumerState<JoinGame> {

  // Controllers
  final roomIdTextController = TextEditingController();
  final roomPasswordTextController = TextEditingController();

  // Focus nodes
  final roomIdFocusNode = FocusNode();
  final roomPasswordFocusNode = FocusNode();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final gameRoomStateNotifier = ref.watch(gameRoomStateProvider.notifier);
    gameRoomStateNotifier.resetGameRoom();
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
                        hintText: AppLanguage.getLanguageData()['Enter the room id'],
                        obscureText: false,
                        textController: roomIdTextController,
                        readOnly: false,
                        autoFocus: false,
                        width: ScreenSize.screenWidth * 0.85,
                        height: ScreenSize.screenHeight * 0.065,
                        currentFocusNode: roomIdFocusNode,
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
                        onPressed: () async {
                          Document? gameRoomDocument = await getGameRoom(
                            ref,
                            roomIdTextController.text.trim(),
                            context,
                          );
                          if (gameRoomDocument != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WaitingRoom(
                                  playerAmount: gameRoomDocument.data['playerAmount'],
                                  gameRoomId: gameRoomDocument.$id),
                              ),
                            );
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
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: ScreenSize.screenHeight * 0.04 +
                      ScreenSize.screenWidth * 0.04,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchGameRoom()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
