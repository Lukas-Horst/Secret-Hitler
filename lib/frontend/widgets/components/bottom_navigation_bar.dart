// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomBottomNavigationBar({super.key, required this.children,
    required this.mainAxisAlignment, required this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.screenHeight * 0.075,
      decoration: BoxDecoration(
        color: AppDesign.getTertiaryColor(),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Children are adjustable
          ...children,
        ],
      ),
    );
  }
}

typedef IntFunction = void Function(int value);

// A pagination widget
class Pagination extends StatefulWidget {

  final int pages;
  final double fontSize;
  final Color textColor;
  final int? startIndex;
  final IntFunction pageChange;

  const Pagination({super.key, required this.pages, required this.fontSize,
    required this.textColor, required this.pageChange, this.startIndex});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {

  int _activePage = 0;

  // A method to get the numbers aligned
  EdgeInsets getRightPadding(int index) {
    if (index > 1 && index != 5) {
      return EdgeInsets.only(bottom: ScreenSize.screenHeight * 0.005);
    } else if (index == 5) {
      return EdgeInsets.only(top: ScreenSize.screenHeight * 0.005);
    } else {
      return const EdgeInsets.only();
    }
  }

  @override
  void initState() {
    if (widget.startIndex != null) {
      _activePage = widget.startIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.pages,
        (index) => Padding(
          padding: getRightPadding(index),
          child: CustomTextButton(
            text: (index + 1).toString(),
            textStyle: TextStyle(
              fontFamily: 'EskapadeFrakturW04BlackFamily',
              fontSize: widget.fontSize,
              color: _activePage == index
                  ? Colors.white
                  : widget.textColor,
              decoration: _activePage == index
                  ? TextDecoration.underline
                  : null,
              decorationColor: Colors.white,
            ),
            onTap: () {
              setState(() {
                _activePage = index;
                widget.pageChange(index);
              });
            },
          ),
        ),
      ),
    );
  }
}

