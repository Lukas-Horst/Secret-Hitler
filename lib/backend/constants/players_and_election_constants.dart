// author: Lukas Horst

import 'package:secret_hitler/backend/constants/screen_size.dart';

class PlayersAndElectionConstants{
  static late List<double> playerWidgetLeftPositions;
  static late List<double> playerWidgetTopPositions;

  static void init() {
    playerWidgetLeftPositions = [
      0,  // Left position
      ScreenSize.screenWidth * 0.51,  // Right position
      ScreenSize.screenWidth * 0.255, // Middle position
    ];

    playerWidgetTopPositions = [
      ScreenSize.screenHeight * 0.05,  // 1th player widget position
      ScreenSize.screenHeight * 0.25,  // 2th player widget position
      ScreenSize.screenHeight * 0.35,  // 3th player widget position
      ScreenSize.screenHeight * 0.45,  // 4th player widget position
      ScreenSize.screenHeight * 0.55,  // 5th player widget position
      ScreenSize.screenHeight * 0.65,  // 6th player widget position
      ScreenSize.screenHeight * 0.13,  // President sign
      ScreenSize.screenHeight * 0.19,  // Chancellor sign
    ];
  }
}