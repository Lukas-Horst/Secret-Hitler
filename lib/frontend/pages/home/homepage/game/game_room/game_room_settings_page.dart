// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';

class GameRoomSettings extends StatefulWidget {

  const GameRoomSettings({super.key,});

  @override
  State<GameRoomSettings> createState() => _GameRoomSettingsState();
}

class _GameRoomSettingsState extends State<GameRoomSettings> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
