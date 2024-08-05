// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/bottom_sheets/bottom_sheet.dart';
import 'package:secret_hitler/frontend/widgets/bottom_sheets/join_game_room_bottom_sheet.dart';
import 'package:secret_hitler/frontend/widgets/components/text/adjustable_standard_text.dart';

class WaitingRoomTableCell extends ConsumerWidget {

  final Document gameRoomDocument;
  final String hostName;

  const WaitingRoomTableCell({super.key, required this.gameRoomDocument,
    required this.hostName,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: ScreenSize.screenHeight * 0.055,
      decoration: BoxDecoration(
        color: AppDesign.getPrimaryColor(),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          // Room number
          Padding(
            padding: EdgeInsets.only(
              left: ScreenSize.screenWidth * 0.01,
            ),
            child: Container(
              height: ScreenSize.screenHeight * 0.055,
              width: ScreenSize.screenWidth * 0.15,
              decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(
                      color: Colors.black,
                      width: 3,
                    )
                ),
              ),
              child: Center(
                child: AdjustableStandardText(
                  text: gameRoomDocument.data['roomNumber'].toString(),
                  color: Colors.white,
                  size: ScreenSize.screenHeight * 0.02 +
                      ScreenSize.screenWidth * 0.02,
                ),
              ),
            ),
          ),

          // Host name
          SizedBox(
            height: ScreenSize.screenHeight * 0.056,
            width: ScreenSize.screenWidth * 0.65,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.screenWidth * 0.01),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: AdjustableStandardText(
                    text: hostName,
                    color: Colors.white,
                    size: ScreenSize.screenHeight * 0.02 +
                        ScreenSize.screenWidth * 0.02,
                  ),
                ),
              ),
            ),
          ),

          // Join button
          Container(
            height: ScreenSize.screenHeight * 0.055,
            width: ScreenSize.screenWidth * 0.10,
            decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(
                    color: Colors.black,
                    width: 3,
                  )
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.login,
                size: ScreenSize.screenHeight * 0.025 +
                    ScreenSize.screenWidth * 0.025,
                color: Colors.white,
              ),
              onPressed: () async {
                CustomBottomSheet _joinGameRoomBottomSheet = joinGameRoomBottomSheet(
                  gameRoomDocument,
                  context,
                  ref,
                );
                _joinGameRoomBottomSheet.openBottomSheet(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
