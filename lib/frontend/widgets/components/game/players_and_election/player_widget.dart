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
    GlobalKey<OpacityAnimationState>(),
  ];
  final List<GlobalKey<SizeAnimationState>> _sizeAnimationKeys = [
    GlobalKey<SizeAnimationState>(),
  ];
  bool dividerVisible = false;
  late int _activeExecutivePower;

  List<OpacityAnimation> _getImages() {
    List<OpacityAnimation> imagesList = [];
    List<String> imagesNames = [
      'Execution_White',
      'Call_Special_Election_White',
      'Investigate_Loyalty_White',
    ];
    for (int i=0; i < 4; i++) {
      OpacityAnimation image = OpacityAnimation(
        key: _opacityKeys[i + 1],
        duration: const Duration(milliseconds: 0),
        begin: 0.0,
        end: 1.0,
        child: Center(
          child: Padding(
            padding: i != 1
                ? EdgeInsets.only(right: widget.width * 0.03)
                : const EdgeInsets.all(0),
            child: IconButton(
              onPressed: () {},
              icon: i == 3
                  ? Icon(
                Icons.how_to_vote,
                color: Colors.white,
                size: ScreenSize.screenHeight * 0.028 +
                    ScreenSize.screenWidth * 0.028,)
                  : Image.asset(
                'assets/images/${imagesNames[i]}.png',
                height: i != 1
                    ? ScreenSize.screenHeight * 0.045
                    : ScreenSize.screenHeight * 0.05,
                width: i != 1
                    ? ScreenSize.screenHeight * 0.045
                    : ScreenSize.screenHeight * 0.05,
              ),
            ),
          ),
        ),
      );
      imagesList.add(image);
    }
    return imagesList;
  }

  // Method to make the divider visible or invisible
  Future<void> dividerVisibility() async {
    if (dividerVisible) {
      _opacityKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 850));
      _sizeAnimationKeys[0].currentState?.animate();
      dividerVisible = false;
      await Future.delayed(const Duration(milliseconds: 1350));
      _opacityKeys[_activeExecutivePower].currentState?.animate();
    } else {
      _sizeAnimationKeys[0].currentState?.animate();
      await Future.delayed(const Duration(milliseconds: 1500));
      _opacityKeys[0].currentState?.animate();
      dividerVisible = true;
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  // Method to change the image of the next image
  Future<void> changeActionImage(int executivePower) async {
    _activeExecutivePower = executivePower;
    if (!dividerVisible) {
      _opacityKeys[_activeExecutivePower].currentState?.animate();
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
            begin: 0.0,
            end: 1.0,
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
                    children: _getImages(),
                  ),
                ),
              ],
            ),
          ),
          SizeAnimation(
            key: _sizeAnimationKeys[0],
            duration: const Duration(milliseconds: 1500),
            firstHeight: widget.height,
            firstWidth: widget.width,
            secondHeight: widget.height,
            secondWidth: widget.width/1.4 - 1.5,
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
