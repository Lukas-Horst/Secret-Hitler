// author: Lukas Horst

import 'package:secret_hitler/backend/constants/screen_size.dart';

final List<double> playerWidgetPositions = [
  0,  // Left position
  ScreenSize.screenWidth * 0.51,  // Right position
  ScreenSize.screenWidth * 0.255, // Middle position
];

final List<double> playerWidgetTopPositions = [
  ScreenSize.screenHeight * 0.05,  // 1th player widget position
  ScreenSize.screenHeight * 0.165,  // 2th player widget position
  ScreenSize.screenHeight * 0.28,  // 3th player widget position
  ScreenSize.screenHeight * 0.395,  // 4th player widget position
  ScreenSize.screenHeight * 0.51,  // 5th player widget position
  ScreenSize.screenHeight * 0.13,  // President sign
  ScreenSize.screenHeight * 0.19,  // Chancellor sign
];