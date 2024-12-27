// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_state_collection_functions.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/waiting_room/qr_code_join_page.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/activate_widget.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/snackbar.dart';
import 'package:secret_hitler/frontend/widgets/components/text/adjustable_standard_text.dart';
import 'package:secret_hitler/frontend/widgets/components/text/explaining_text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class WaitingRoom extends ConsumerStatefulWidget {

  final Document gameRoomDocument;

  const WaitingRoom({super.key, required this.gameRoomDocument});

  @override
  ConsumerState<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends ConsumerState<WaitingRoom> {

  late List _playerNames;
  bool _firstBuild = true;

  Future<void> _goBack(BuildContext context, WidgetRef ref,
      GameRoomStateNotifier gameRoomStateNotifier, Document gameRoomDocument) async {
    gameRoomStateNotifier.resetGameRoom();
    await leaveWaitingRoom(ref, gameRoomDocument, context);
  }

  // Method to create the list of the player names who are currently in the
  // waiting room
  Column _showPlayerNames() {
    List<Widget> nameRows = [];
    int maxIterations = ceilingDivision(_playerNames.length, 2);
    for (int i=0; i < maxIterations; i++) {
      List<Widget> names = [];
      // Always add the first name
      names.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: ScreenSize.screenWidth * 0.43,
          child: AdjustableStandardText(
            text: '• ${_playerNames[i*2]}',
            color: Colors.white,
            size: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
          ),
        ),
      ));
      // Checking if we can add a second name in the row if we have on left
      if (_playerNames.length % 2 == 0 || i != maxIterations - 1) {
        names.add(AdjustableStandardText(
          text: '• ${_playerNames[i*2 + 1]}',
          color: Colors.white,
          size: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
        ));
      }

      nameRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: names,
      ));
      nameRows.add(SizedBox(height: ScreenSize.screenHeight * 0.01),);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nameRows,
    );
  }

  // Method to update the player names with all names which are currently in
  // the game room
  Future<void> _updatePlayerName(DatabaseApi databaseApi) async {
    Document? gameRoomDocument = await databaseApi.getDocumentById(
      gameRoomCollectionId,
      widget.gameRoomDocument.$id,
    );
    List<dynamic> players = gameRoomDocument!.data['users'];
    List<String> playerNames = [];
    for (Map<String, dynamic> player in players) {
      playerNames.add(player['userName']);
    }
    setState(() {
      _playerNames = playerNames;
    });
  }

  @override
  void initState() {
    _playerNames = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final databaseApi = ref.watch(databaseApiProvider);
    final gameRoomStateNotifier = ref.watch(gameRoomStateProvider.notifier);
    final gameRoomState = ref.watch(gameRoomStateProvider);
    if (gameRoomState.gameRoomDocument == null && _firstBuild) {
      _firstBuild = false;
      gameRoomStateNotifier.setGameRoom(widget.gameRoomDocument.$id);
    } else if (gameRoomState.gameRoomDocument != null) {
      if (gameRoomState.gameRoomDocument!.data['users'] != null) {
        if (gameRoomState.gameRoomDocument!.data['users'].length
            != _playerNames.length) {
          _updatePlayerName(databaseApi);
        }
      }
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {
          _goBack(context, ref, gameRoomStateNotifier,
            gameRoomState.gameRoomDocument!,);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              Header(headerText: '${AppLanguage.getLanguageData()['Waiting room']} '
                  '(${AppLanguage.getLanguageData()['NO']}:'
                  ' ${widget.gameRoomDocument.data['roomNumber']})'),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Room id']}:',
              ),
              ExplainingText(
                text: widget.gameRoomDocument.$id,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Number of players']}:',
              ),
              ExplainingText(
                text: '${_playerNames.length}/'
                    '${widget.gameRoomDocument.data['playerAmount']}',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Players']}:',
              ),
              SizedBox(
                width: ScreenSize.screenWidth * 0.90,
                height: ScreenSize.screenHeight * 0.28,
                child: _showPlayerNames(),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.01),
              PrimaryElevatedButton(
                text: AppLanguage.getLanguageData()['Start game'],
                onPressed: () async {
                  if (_playerNames.length <= widget.gameRoomDocument.data['playerAmount']
                      && _playerNames.length > 4) {
                    startGame(ref, gameRoomState.gameRoomDocument!,
                      context, gameRoomStateNotifier,);
                  } else {
                    CustomSnackbar.showSnackbar(
                      AppLanguage.getLanguageData()['Too few players'],
                      Colors.red,
                      const Duration(seconds: 3),
                    );
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: ActivateWidget(
            child: CustomBottomNavigationBar(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NavigationBackButton(onPressed: () {
                  _goBack(context, ref, gameRoomStateNotifier,
                    gameRoomState.gameRoomDocument!,);
                }),
                IconButton(
                  icon: Icon(
                    Icons.qr_code,
                    size: ScreenSize.screenHeight * 0.04 +
                        ScreenSize.screenWidth * 0.04,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    newPage(context, QrCodeJoin(waitingRoomId: widget.gameRoomDocument.$id));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
