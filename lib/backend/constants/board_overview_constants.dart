// author: Lukas Horst

import 'package:secret_hitler/backend/constants/screen_size.dart';

// All necessary positions on the board overview page
class BoardOverviewPositions{

  static late List<double> constantTopPositions;
  static late List<double> constantLeftPositions;
  static late List<double> fascistBoardLeftPositions;
  static late List<double> liberalBoardLeftPositions;
  static late List<double> cardHeights;
  static late double cardWidth;

  static void init() {
    constantTopPositions = [
      ScreenSize.screenHeight * 0.075,  // Fascist board
      ScreenSize.screenHeight * 0.25,  // Liberal board
      ScreenSize.screenHeight * 0.4155, // Draw and discard pile (top card)
      ScreenSize.screenHeight * 0.65,  // Bottom center
    ];
    constantLeftPositions = [
      ScreenSize.screenWidth * 0.068, // Draw pile (top card)
      ScreenSize.screenWidth * 0.8015,  // Discard pile (top card)
      ScreenSize.screenWidth * 0.43,  // Bottom center (middle card)
    ];
    fascistBoardLeftPositions = [
      ScreenSize.screenWidth * 0.1035,  // 1th card
      ScreenSize.screenWidth * 0.235,  // 2th card
      ScreenSize.screenWidth * 0.3665,  // 3th card
      ScreenSize.screenWidth * 0.499,  // 4th card
      ScreenSize.screenWidth * 0.6325,  // 5th card
      ScreenSize.screenWidth * 0.765,  // 6th card
    ];
    liberalBoardLeftPositions = [
      ScreenSize.screenWidth * 0.1675,  // 1th card
      ScreenSize.screenWidth * 0.3,  // 2th card
      ScreenSize.screenWidth * 0.432,  // 3th card
      ScreenSize.screenWidth * 0.5625,  // 4th card
      ScreenSize.screenWidth * 0.6975,  // 5th card
    ];
    cardHeights = [
      ScreenSize.screenHeight * 0.08,  // Normal height
      ScreenSize.screenHeight * 0.75  // Board height
    ];
    cardWidth = ScreenSize.screenWidth * 0.115;
  }

}