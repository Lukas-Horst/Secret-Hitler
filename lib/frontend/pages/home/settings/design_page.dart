// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';
import 'package:secret_hitler/frontend/widgets/animations/coin_flip.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class Design extends StatefulWidget {

  const Design({super.key});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {

  final Color _currentPrimaryColor = AppDesign.getPrimaryColor();
  final GlobalKey<CoinFlipState> _coinFlipKey = GlobalKey<CoinFlipState>();

  void _goBack(BuildContext context) {
    Navigator.pop(context);
    // If the design changed, we replace the settings page
    if (_currentPrimaryColor != AppDesign.getPrimaryColor()) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageNavigation(startPage: 2,))
      );
    }
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
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Header(headerText: AppLanguage.getLanguageData()['Design']),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Choose theme.'],
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.1),
              CoinFlip(
                key: _coinFlipKey,
                duration: const Duration(milliseconds: 500),
                firstImageName: AppDesign.getCurrentCirclePNG(),
                secondImageName: AppDesign.getOppositeCirclePNG(),
                imageHeight: ScreenSize.screenHeight * 0.15,
                imageWidth: ScreenSize.screenHeight * 0.15,
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.06),
              CustomToggleButton(
                height: ScreenSize.screenHeight * 0.065,
                width: ScreenSize.screenWidth * 0.85,
                leftColor: const Color(0xffDC0606),
                rightColor: const Color(0xff004D65),
                leftFunction: () async {
                  await AppDesign.setPrimaryColor(const Color(0xffDC3B06));
                  // setState(() {});
                  _coinFlipKey.currentState?.animate();
                },
                rightFunction: () async {
                  await AppDesign.setPrimaryColor(const Color(0xff479492));
                  // setState(() {});
                  _coinFlipKey.currentState?.animate();
                },
                leftText: AppLanguage.getLanguageData()['Fascist'],
                rightText: AppLanguage.getLanguageData()['Liberal'],
                leftActive: _currentPrimaryColor == const Color(0xffDC3B06),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationBackButton(onPressed: () {
              _goBack(context);
            }),
          ],
        ),
      ),
    );
  }
}
