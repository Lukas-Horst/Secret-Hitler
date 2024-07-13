// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

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