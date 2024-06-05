// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class WaitingRoom extends StatefulWidget {

  final int playerAmount;
  final String roomName;
  final String hostName;

  const WaitingRoom({super.key, required this.playerAmount,
    required this.roomName, required this.hostName});

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {

  late List _playerNames;

  void _goBack(BuildContext context) {
    Navigator.pop(context);
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

  @override
  void initState() {
    _playerNames = [widget.hostName, 'Test', 'Test'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Header(headerText: AppLanguage.getLanguageData()['Waiting room']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Room name']}:',
              ),
              ExplainingText(
                text: widget.roomName,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
              ExplainingText(
                text: '${AppLanguage.getLanguageData()['Number of players']}:',
              ),
              ExplainingText(
                text: '${widget.playerAmount}',
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.04),
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
                _goBack(context);
              }),
              IconButton(
                icon: Icon(
                  Icons.person_add,
                  size: ScreenSize.screenHeight * 0.04 +
                      ScreenSize.screenWidth * 0.04,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
