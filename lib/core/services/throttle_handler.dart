import 'dart:async';

import 'package:flutter/material.dart';

class ThrottleHandler {
  ThrottleHandler({required this.throttleDuration});
  Timer? _throttleTimer;
  final Duration throttleDuration;
  bool _isThrottled = false;

  void onCallback(VoidCallback action) {
    if (_isThrottled) {
      return;
    }

    _isThrottled = true;
    action();

    // Start the throttle timer
    _throttleTimer = Timer(throttleDuration, () {
      _isThrottled = false;
    });
  }

  void dispose() {
    _throttleTimer?.cancel();
  }
}
