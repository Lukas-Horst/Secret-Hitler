// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/helper/math_functions.dart';
import 'package:secret_hitler/frontend/widgets/animations/opacity_animation.dart';
import 'package:secret_hitler/frontend/widgets/animations/size_animation.dart';

// A widget to display each player name and their actions
class PlayerWidget extends StatefulWidget {

  final String playerName;
  final double height;
  final double width;

  const PlayerWidget({super.key, required this.playerName, required this.height,
    required this.width});

  @override
  State<PlayerWidget> createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {

  final List<GlobalKey<OpacityAnimationState>> _opacityKeys = [
    GlobalKey<OpacityAnimationState>(),
    GlobalKey<OpacityAnimationState>(),
    GlobalKey<OpacityAnimationState>(),
    GlobalKey<OpacityAnimationState>(),
  ];
  final List<GlobalKey<SizeAnimationState>> _sizeAnimationKeys = [
    GlobalKey<SizeAnimationState>(),
  ];
  bool dividerVisible = true;
  late int _activeExecutivePower;

  // Method to make the divider visible or invisible
  Future<void> dividerVisibility() async {
    if (dividerVisible) {
      _opacityKeys[0].currentState?.animate();
      _opacityKeys[_activeExecutivePower].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 850));
      _sizeAnimationKeys[0].currentState?.animate();
      dividerVisible = false;
      await Future.delayed(const Duration(milliseconds: 1350));
    } else {
      _sizeAnimationKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1500));
      _opacityKeys[0].currentState?.animate();
      dividerVisible = true;
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  // Method to change the image of the next image
  Future<void> changeActionImage(String executivePower) async {
    if (executivePower == 'Kill') {
      _activeExecutivePower = 1;
    }
    if (!dividerVisible) {
      _opacityKeys[1].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppDesign.getPrimaryColor(),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              border: Border.all(color: Colors.black, width: 3),
            ),
          ),
          OpacityAnimation(
            key: _opacityKeys[0],
            duration: const Duration(milliseconds: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side
                Container(
                  height: widget.height,
                  width: widget.width - widget.width/3 - 1.5,
                  decoration: BoxDecoration(
                    color: AppDesign.getPrimaryColor(),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    border: const Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                      top: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: VerticalDivider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                ),
                // Right size
                Container(
                  height: widget.height,
                  width: widget.width/3 - 1.5,
                  decoration: BoxDecoration(
                    color: AppDesign.getPrimaryColor(),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    border: const Border(
                      right: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                      top: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      OpacityAnimation(
                        key: _opacityKeys[1],
                        duration: const Duration(milliseconds: 1000),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: widget.width * 0.03),
                            child: Image.asset(
                              'assets/images/Execution_White.png',
                              height: ScreenSize.screenHeight * 0.045,
                              width: ScreenSize.screenHeight * 0.045,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizeAnimation(
            key: _sizeAnimationKeys[0],
            duration: const Duration(milliseconds: 1500),
            firstHeight: widget.height,
            firstWidth: widget.width/1.4 - 1.5,
            secondHeight: widget.height,
            secondWidth: widget.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.playerName,
                    style: TextStyle(
                      fontFamily: 'EskapadeFrakturW04BlackFamily',
                      color: Colors.white,
                      fontSize: ScreenSize.screenHeight * 0.02 +
                          ScreenSize.screenWidth * 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
