// author: Lukas Horst

import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {

  final PageController controller;
  final List<Widget> children;

  const CustomPageView({super.key, required this.controller,
    required this.children});

  @override
  State<CustomPageView> createState() => CustomPageViewState();
}

class CustomPageViewState extends State<CustomPageView> {

  ScrollPhysics scrollPhysics = const ScrollPhysics();

  // Method to make the page view scrollable or unscrollable
  void changeScrollPhysics(bool scrollable) {
    setState(() {
      if (scrollable) {
        scrollPhysics = const ScrollPhysics();
      } else {
        scrollPhysics = const NeverScrollableScrollPhysics();
      }
    });
  }

  // Method to change the page
  void changePage(int pageNumber) {
    widget.controller.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      physics: scrollPhysics,
      children: widget.children,
    );
  }
}
