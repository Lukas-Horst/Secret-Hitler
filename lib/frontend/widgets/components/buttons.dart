// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/transformedWidgets.dart';

// Text button without too much space around
class CustomTextButton extends StatefulWidget {

  final String text;
  final TextStyle textStyle;
  final Function() onTap;

  const CustomTextButton({super.key, required this.text,
    required this.textStyle, required this.onTap});

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: RichText(
        text: TextSpan(
          text: widget.text,
          style: widget.textStyle,
        ),
      ),
    );
  }
}

// The standard elevated button design
class PrimaryElevatedButton extends StatefulWidget {

  final String text;
  final Function() onPressed;

  const PrimaryElevatedButton({super.key, required this.text, required this.onPressed});

  @override
  State<PrimaryElevatedButton> createState() => _PrimaryElevatedButtonState();
}

class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.getSecondaryColor(),
          foregroundColor: Colors.black,
          fixedSize: Size(
            ScreenSize.screenWidth * 0.85,
            ScreenSize.screenHeight * 0.065,
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          )
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'EskapadeFrakturW04BlackFamily',
          fontSize: ScreenSize.screenHeight * 0.025 +
              ScreenSize.screenWidth * 0.025,
        ),
      ),
    );
  }
}

// The back button on the navigation bar
class NavigationBackButton extends StatefulWidget {

  final Function() onPressed;

  const NavigationBackButton({super.key, required this.onPressed});

  @override
  State<NavigationBackButton> createState() => _NavigationBackButtonState();
}

class _NavigationBackButtonState extends State<NavigationBackButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: ScreenSize.screenHeight * 0.04 +
            ScreenSize.screenWidth * 0.04,
        color: Colors.white,
      ),
      onPressed: widget.onPressed,
    );
  }
}

// Custom toggle button which is used on the design page
class CustomToggleButton extends StatefulWidget {

  final double height;
  final double width;
  final Color leftColor;
  final Color rightColor;
  final Function leftFunction;
  final Function rightFunction;
  final String leftText;
  final String rightText;
  final bool leftActive;

  const CustomToggleButton({super.key, required this.height,
    required this.width, required this.leftColor, required this.rightColor,
    required this.leftFunction, required this.rightFunction,
    required this.leftText, required this.rightText, required this.leftActive});

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {

  late bool _leftActive;

  @override
  void initState() {
    _leftActive = widget.leftActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widget.width/2 - 1.5,
            height: widget.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              border: Border(
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
              )
            ),
            child: ElevatedButton(
              onPressed: () {
                // The function will only executed if it is the inactive button
                if (!_leftActive) {
                  widget.leftFunction();
                  setState(() {
                    _leftActive = !_leftActive;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.leftColor,
                  foregroundColor: Colors.black,
                  fixedSize: Size(widget.width/2, widget.height),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
              ),
              child: Text(
                widget.leftText,
                style: TextStyle(
                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                  fontSize: ScreenSize.screenHeight * 0.025 +
                      ScreenSize.screenWidth * 0.025,
                  decoration: _leftActive
                      ? TextDecoration.underline
                      : null,
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
          Container(
            width: widget.width/2 - 1.5,
            height: widget.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                border: Border(
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
                )
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_leftActive) {
                  widget.rightFunction();
                  setState(() {
                    _leftActive = !_leftActive;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.rightColor,
                foregroundColor: Colors.black,
                fixedSize: Size(widget.width/2, widget.height),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              child: Text(
                widget.rightText,
                style: TextStyle(
                  fontFamily: 'EskapadeFrakturW04BlackFamily',
                  fontSize: ScreenSize.screenHeight * 0.025 +
                      ScreenSize.screenWidth * 0.025,
                  decoration: _leftActive
                      ? null
                      : TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThirdPartyButton extends StatefulWidget {

  final String imageName;
  final Function onPressed;

  const ThirdPartyButton({super.key, required this.imageName,
    required this.onPressed});

  @override
  State<ThirdPartyButton> createState() => _ThirdPartyButtonState();
}

class _ThirdPartyButtonState extends State<ThirdPartyButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {widget.onPressed();},
      icon: Image.asset(
        'assets/images/${widget.imageName}.png',
      ),
      style: IconButton.styleFrom(
          backgroundColor: AppDesign.getSecondaryColor(),
          foregroundColor: Colors.black,
          fixedSize: Size(
            ScreenSize.screenWidth * 0.2125,
            ScreenSize.screenHeight * 0.065,
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          )
      ),
    );
  }
}

// The whole area on the login or register page where we switch the pages
class LoginRegisterSwitchButton extends StatefulWidget {

  final String questionText;
  final String buttonText;
  final Function onTap;

  const LoginRegisterSwitchButton({super.key, required this.questionText,
    required this.buttonText, required this.onTap});

  @override
  State<LoginRegisterSwitchButton> createState() => _LoginRegisterSwitchButtonState();
}

class _LoginRegisterSwitchButtonState extends State<LoginRegisterSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AngleWidget(
          angleDegree: 330,
          child: Image.asset(
            'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenHeight * 0.07,
          ),
        ),
        Column(
          children: [
            Text(
              widget.questionText,
              style: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                fontSize: ScreenSize.screenHeight * 0.017 +
                    ScreenSize.screenWidth * 0.017,
                color: Colors.white,
              ),
            ),
            SizedBox(height: ScreenSize.screenHeight * 0.005),
            CustomTextButton(
              text: widget.buttonText,
              textStyle: TextStyle(
                fontFamily: 'EskapadeFrakturW04BlackFamily',
                fontSize: ScreenSize.screenHeight * 0.017 +
                    ScreenSize.screenWidth * 0.017,
                color: AppDesign.getContraryPrimaryColor(),
                decoration: TextDecoration.underline,
              ),
              onTap: () {widget.onTap();},
            ),
          ],
        ),
        AngleWidget(
          angleDegree: -330,
          child: Image.asset(
            'assets/images/${AppDesign.getCurrentCirclePNG()}.png',
            height: ScreenSize.screenHeight * 0.075,
            width: ScreenSize.screenHeight * 0.07,
          ),
        ),
      ],
    );
  }
}

