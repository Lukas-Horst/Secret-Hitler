// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
import 'package:secret_hitler/backend/pages/game/game_room/game_state_functions.dart';

class CustomPageView extends ConsumerStatefulWidget {

  final PageController controller;
  final List<Widget> children;
  final int firstPage;

  const CustomPageView({super.key, required this.controller,
    required this.children, required this.firstPage});

  @override
  ConsumerState<CustomPageView> createState() => CustomPageViewState();
}

class CustomPageViewState extends ConsumerState<CustomPageView> {

  ScrollPhysics _scrollPhysics = const ScrollPhysics();
  late int currentPage;

  // Method to make the page view scrollable or unscrollable
  Future<void> changeScrollPhysics(bool scrollable, Duration? duration,
      int? newPage) async {
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
      changeScrollPhysics(!scrollable, null, null);
    }
    // Changing to a new page if it is given
    if (newPage != null) {
      await changePage(newPage);
    }
  }

  // Method to change the page
  Future<void> changePage(int pageNumber) async {
    if (currentPage != pageNumber) {
      widget.controller.animateToPage(
        pageNumber,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    currentPage = widget.firstPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      physics: _scrollPhysics,
      onPageChanged: (int page) {
        currentPage = page;
        checkProgressBlocks(ref);
      },
      children: widget.children,
    );
  }
}
