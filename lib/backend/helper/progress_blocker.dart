// author: Lukas Horst

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Class to block a specific progress until it is manually allowed
class ProgressBlocker extends StateNotifier<bool> {

  Completer<void>? _completer;

  ProgressBlocker() :super(true);

  // Method to wait until the attribute isUpdated is true
  Future<void> waitForUpdate() async {
    if (state) {
      return Future.value();
    } else {
      _completer ??= Completer<void>();
      return _completer!.future;
    }
  }

  // Method to update the completer base on the given bool
  void updateCompleter(bool update) {
    if (update != state) {
      state = update;
      // Completing the completer is it already existed and the state is true
      if (_completer != null && !_completer!.isCompleted && state) {
        _completer!.complete();
        _completer = null;
      }
    }
  }
}