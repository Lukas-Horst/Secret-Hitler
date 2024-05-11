// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/text.dart';

class ScrollWheel extends StatefulWidget {

  final int firstNumber;
  final int lastNumber;
  final double itemExtent;
  final FixedExtentScrollController scrollController;

  const ScrollWheel({super.key, required this.firstNumber,
    required this.lastNumber, required this.itemExtent,
    required this.scrollController});

  @override
  State<ScrollWheel> createState() => _ScrollWheelState();
}

class _ScrollWheelState extends State<ScrollWheel> {
  // A method to get the numbers aligned
  EdgeInsets getRightPadding(int index) {
    if (index == 6 || index == 8) {
      return EdgeInsets.only(top: ScreenSize.screenHeight * 0.004);
    } else {
      return const EdgeInsets.only();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.screenHeight * 0.004),
      child: ListWheelScrollView.useDelegate(
        itemExtent: widget.itemExtent,
        controller: widget.scrollController,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.lastNumber - widget.firstNumber + 1,
          builder: (context, index) {
            return Padding(
              padding: getRightPadding(index + widget.firstNumber),
              child: AdjustableStandardText(
                text: (index + widget.firstNumber).toString(),
                color: Colors.white,
                size: ScreenSize.screenHeight * 0.0225 +
                    ScreenSize.screenWidth * 0.0225,
              ),
            );
          },
        ),
      ),
    );
  }
}
