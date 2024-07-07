// author: Lukas Horst

// Class to start a timer or close the timer
import 'dart:async';

class CustomTimer {

  bool _timerActive = false;
  Timer? _timer;

  Future<void> startTimer(Duration interval, Function function,
      Duration? maxTime) async {
    if (!_timerActive) {
      _timerActive = true;
      // Run the function also on the initialization
      function();
      _timer = Timer.periodic(interval, (Timer timer) {
        function();
      });
      // Closing the timer after the max time if it is given
      if (maxTime != null) {
        await Future.delayed(maxTime);
        stopTimer();
      }
    }
  }

  void stopTimer() {
    if (_timerActive) {
      _timer!.cancel();
      _timerActive = false;
    }
  }
}