// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';

class CustomBottomSheet {
  bool _activated = false;
  late final List<Widget> _children;
  late final bool _dismissible;
  late final double _height;

  CustomBottomSheet(this._children, this._dismissible, this._height);

  // Method to open the bottom sheet if it isn't already opened
  void openBottomSheet(BuildContext context) {
    if (!_activated) {
      _activated = true;
      showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: _dismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: ScreenSize.bottomViewInsets),
            child: Container(
              height: _height,
              width: ScreenSize.screenWidth,
              decoration: const BoxDecoration(
                  color: Color(0xFF6A6A6A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ScreenSize.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: ScreenSize.screenHeight * 0.04 +
                                ScreenSize.screenWidth * 0.04,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            closeBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  ..._children,
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Method to close the bottom sheet if it is open
  void closeBottomSheet(BuildContext context) {
    if (_activated) {
      Navigator.of(context).pop();
    }
    _activated = false;
  }
}