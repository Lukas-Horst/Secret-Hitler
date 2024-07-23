// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';
import 'package:secret_hitler/backend/database/appwrite/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/backend/helper/useful_functions.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/game/joining/waiting_room/qr_code_join_page.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/navigation_back_button.dart';
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
      GameRoomStateNotifier gameRoomStateNotifier) async {
    gameRoomStateNotifier.resetGameRoom();
    await leaveWaitingRoom(ref, widget.gameRoomDocument, context);
  }

  // Method to create the list of the player names who are currently in the
  // waiting room
  Column _showPlayerNames() {
    List<Widget> nameRows = [];
    int maxIterations = ceilingDivision(_playerNames.length, 2);
    for (int i=0; i < maxIterations; i++) {
      List<AdjustableStandardText> names = [];
      // Always add the first name
      names.add(AdjustableStandardText(
        text: '• ${_playerNames[i*2]}',
        color: Colors.white,
        size: ScreenSize.screenHeight * 0.02 + ScreenSize.screenWidth * 0.02,
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
      if (gameRoomState.gameRoomDocument!.data['users'].length
          != _playerNames.length) {
        _updatePlayerName(databaseApi);
      }
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (!didpop) {
          _goBack(context, ref, gameRoomStateNotifier);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              Header(headerText: AppLanguage.getLanguageData()['Waiting room']),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Number of players']}:',
              ),
              ExplainingText(
                text: '${widget.gameRoomDocument.data['users'].length}/'
                    '${widget.gameRoomDocument.data['playerAmount']}',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.06),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Players']}:',
              ),
              SizedBox(
                width: ScreenSize.screenWidth * 0.90,
                child: _showPlayerNames(),),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavigationBackButton(onPressed: () {
                _goBack(context, ref, gameRoomStateNotifier);
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
    );
  }
}
