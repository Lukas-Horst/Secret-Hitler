// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
import 'package:secret_hitler/backend/helper/timer.dart';

class CustomPageView extends StatefulWidget {

  final PageController controller;
  final List<Widget> children;
  final int firstPage;

  const CustomPageView({super.key, required this.controller,
    required this.children, required this.firstPage});

  @override
  State<CustomPageView> createState() => CustomPageViewState();
}

class CustomPageViewState extends State<CustomPageView> {

  ScrollPhysics _scrollPhysics = const ScrollPhysics();
  late int _currentPage;

  // Method to make the page view scrollable or unscrollable
  Future<void> changeScrollPhysics(bool scrollable, Duration? duration,
      int? newPage, ProgressBlocker? progressBlocker) async {
    // Checking if a change is needed
    if ((_scrollPhysics != const ScrollPhysics() && scrollable)
        || (_scrollPhysics == const ScrollPhysics() && !scrollable)) {
      setState(() {
        if (scrollable) {
          _scrollPhysics = const ScrollPhysics();
        } else {
          _scrollPhysics = const NeverScrollableScrollPhysics();
        }
      });
    }
    // Changing to the old scroll physics back if we have a duration
    if (duration != null) {
      await Future.delayed(duration);
      changeScrollPhysics(!scrollable, null, null, null);
    }
    // Changing to a new page if it is given
    if (newPage != null) {
      await changePage(newPage);
    }
    // If given the progress blocker updates
    if (progressBlocker != null) {
      progressBlocker.updateCompleter(true);
    }
  }

  // Method to change the page
  Future<void> changePage(int pageNumber) async {
    if (_currentPage != pageNumber) {
      widget.controller.animateToPage(
        pageNumber,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  int getCurrentPage() {
    return _currentPage;
  }

  @override
  void initState() {
    _currentPage = widget.firstPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      physics: _scrollPhysics,
      onPageChanged: (int page) {
        _currentPage = page;
      },
      children: widget.children,
    );
  }
}
