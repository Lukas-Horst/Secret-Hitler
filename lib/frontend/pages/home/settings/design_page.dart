// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';
import 'package:secret_hitler/frontend/widgets/animations/bottom_navigation_bar_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/flip_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/header_animation.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/components/transformedWidgets.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';
import 'package:secret_hitler/frontend/widgets/header/header_image.dart';

class Design extends StatefulWidget {

  const Design({super.key});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {

  final Color _currentPrimaryColor = AppDesign.getPrimaryColor();
  final GlobalKey<FlipAnimationState> _flipAnimationKey = GlobalKey<FlipAnimationState>();
  final GlobalKey<HeaderAnimationState> _headerAnimationKey = GlobalKey<HeaderAnimationState>();
  final GlobalKey<CustomBottomNavigationBarAnimationState> _bottomNavigationBarAnimationKey
  = GlobalKey<CustomBottomNavigationBarAnimationState>();

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
              HeaderAnimation(
                key: _headerAnimationKey,
                duration: const Duration(milliseconds: 500),
                headerText: AppLanguage.getLanguageData()['Design'],
                firstColor: AppDesign.getPrimaryColor(),
                secondColor: AppDesign.getContraryPrimaryColor(),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              ExplainingText(
                text: AppLanguage.getLanguageData()['Choose theme.'],
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.1),
              FlipAnimation(
                key: _flipAnimationKey,
                duration: const Duration(milliseconds: 500),
                firstWidget: Image.asset(
                  'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
                  height: ScreenSize.screenHeight * 0.15,
                  width: ScreenSize.screenHeight * 0.15,
                ),
                secondWidget: Image.asset(
                  'assets/images/${AppDesign.getOppositeCirclePNG()}.png',
                  height: ScreenSize.screenHeight * 0.15,
                  width: ScreenSize.screenHeight * 0.15,
                ),
              ),
              SizedBox(height: ScreenSize.screenHeight * 0.06),
              CustomToggleButton(
                height: ScreenSize.screenHeight * 0.065,
                width: ScreenSize.screenWidth * 0.85,
                leftColor: const Color(0xffDC0606),
                rightColor: const Color(0xff004D65),
                leftFunction: () async {
                  await AppDesign.setPrimaryColor(const Color(0xffDC3B06));
                  _flipAnimationKey.currentState?.animate();
                  _headerAnimationKey.currentState?.animate();
                  _bottomNavigationBarAnimationKey.currentState?.animate();
                },
                rightFunction: () async {
                  await AppDesign.setPrimaryColor(const Color(0xff479492));
                  _flipAnimationKey.currentState?.animate();
                  _headerAnimationKey.currentState?.animate();
                  _bottomNavigationBarAnimationKey.currentState?.animate();
                },
                leftText: AppLanguage.getLanguageData()['Fascist'],
                rightText: AppLanguage.getLanguageData()['Liberal'],
                leftActive: _currentPrimaryColor == const Color(0xffDC3B06),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBarAnimation(
          key: _bottomNavigationBarAnimationKey,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          duration: const Duration(milliseconds: 500),
          firstColor: AppDesign.getTertiaryColor(),
          secondColor: AppDesign.getContraryTertiaryColor(),
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
