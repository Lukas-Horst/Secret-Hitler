// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/riverpod/provider.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/refresh_button.dart';
import 'package:secret_hitler/frontend/widgets/components/game/waiting_room/waiting_room_table_cell.dart';
import 'package:secret_hitler/frontend/widgets/components/text/adjustable_standard_text.dart';

class RoomSessionTable extends ConsumerStatefulWidget {

  const RoomSessionTable({super.key,});

  @override
  ConsumerState<RoomSessionTable> createState() => _RoomSessionTableState();
}

class _RoomSessionTableState extends ConsumerState<RoomSessionTable> {

  List<Widget> _gameRoomWidgets = [];
  bool initialLoad = false;

  // Getting all game rooms that are currently in the database
  Future<void> updateGameRooms(WidgetRef ref) async {
    initialLoad = true;
    final databaseApi = ref.watch(databaseApiProvider);
    DocumentList? gameRoomDocuments = await databaseApi.listDocuments(
      gameRoomCollectionId,
      queries: [
        Query.orderAsc('roomNumber'),
      ],
    );
    if (gameRoomDocuments == null) {return;}
    List<Widget> gameRoomWidgets = [];
    for (Document gameRoomDocument in gameRoomDocuments.documents) {
      String hostName = '';
      // Searching for the name of the host of the game room
      for (final user in gameRoomDocument.data['users']) {
        if (user != null) {
          if (user['\$id'] == gameRoomDocument.data['host']) {
            hostName = user['userName'];
            break;
          }
        }
      }
      WaitingRoomTableCell waitingRoomTableCell = WaitingRoomTableCell(
        gameRoomDocument: gameRoomDocument,
        hostName: hostName,
      );
      gameRoomWidgets.add(waitingRoomTableCell);
      gameRoomWidgets.add(SizedBox(height: ScreenSize.screenHeight * 0.01),);
    }
    setState(() {
      _gameRoomWidgets = gameRoomWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initialLoad) {
      updateGameRooms(ref);
    }
    return Center(
      child: SizedBox(
        width: ScreenSize.screenWidth * 0.95,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: ScreenSize.screenWidth * 0.18,
                  child: Center(
                    child: AdjustableStandardText(
                      text: 'NR:',
                      color: Colors.white,
                      size: ScreenSize.screenHeight * 0.02 +
                          ScreenSize.screenWidth * 0.02,
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenSize.screenWidth * 0.65,
                  child: Center(
                    child: AdjustableStandardText(
                      text: 'Host:',
                      color: Colors.white,
                      size: ScreenSize.screenHeight * 0.02 +
                          ScreenSize.screenWidth * 0.02,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.01,),
            SizedBox(
              height: ScreenSize.screenHeight * 0.525,
              child: SingleChildScrollView(
                child: Column(
                  children: _gameRoomWidgets,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RefreshButton(
                  size: ScreenSize.screenHeight * 0.03 +
                    ScreenSize.screenWidth * 0.03,
                  onPressed: () async {
                    await updateGameRooms(ref);
                  },
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
