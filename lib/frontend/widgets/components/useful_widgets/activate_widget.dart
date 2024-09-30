// author: Lukas Horst

import 'package:flutter/material.dart';

// Widget which can change between the given widget and an empty sized box to
// 'deactivate' a widget
class ActivateWidget extends StatefulWidget {

  final Widget child;
  final bool? activated;

  const ActivateWidget({super.key, required this.child, this.activated});

  @override
  State<ActivateWidget> createState() => ActivateWidgetState();
}

class ActivateWidgetState extends State<ActivateWidget> {

  late bool _activated;

  Future<void> activateWidget() async {
    setState(() {
      _activated = true;
    });
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void deactivateWidget() {
    setState(() {
      _activated = false;
    });
  }

  // Method to switch from the one state to the other
  void toggleWidget() {
    if (_activated) {
      deactivateWidget();
    } else {
      activateWidget();
    }
  }

  @override
  void initState() {
    if (widget.activated != null) {
      _activated = widget.activated!;
    } else {
      _activated = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_activated) {
      return widget.child;
    } else {
      return const SizedBox();
    }
  }
}
