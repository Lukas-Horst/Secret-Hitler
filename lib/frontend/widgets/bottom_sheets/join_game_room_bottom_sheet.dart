// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/game_room_collection_functions.dart';
import 'package:secret_hitler/frontend/widgets/bottom_sheets/bottom_sheet.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons/primary_elevated_button.dart';
import 'package:secret_hitler/frontend/widgets/components/text/text_field_head_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';

CustomBottomSheet joinGameRoomBottomSheet(Document gameRoomDocument,
    BuildContext context, WidgetRef ref,) {

  final roomPasswordTextController = TextEditingController();
  final roomPasswordFocusNode = FocusNode();
  final GlobalKey<CustomTextFormFieldState> joinTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  List<Widget> children = [
    SizedBox(height: ScreenSize.screenHeight * 0.01),
    TextFieldHeadText(
      text: '${AppLanguage.getLanguageData()['Players']}: '
          '${gameRoomDocument.data['users'].length}/${gameRoomDocument.data['playerAmount']}',
    ),
    SizedBox(height: ScreenSize.screenHeight * 0.04),
    TextFieldHeadText(
      text: AppLanguage.getLanguageData()['Room password'],
    ),
    CustomTextFormField(
      key: joinTextFieldKey,
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
        if (roomPasswordTextController.text.trim() == gameRoomDocument.data['password']) {
          joinTextFieldKey.currentState?.resetsErrors();
          await joinWaitingRoom(
            ref,
            gameRoomDocument,
            context,
            3,
            null,
          );
        } else {
          joinTextFieldKey.currentState?.showError(
            AppLanguage.getLanguageData()['Wrong password']);
        }
      },
    )
  ];
  return CustomBottomSheet(children, false, ScreenSize.screenHeight * 0.5);
}