import 'dart:async';

import 'package:flutter/foundation.dart';

class DebounceHandler {
  DebounceHandler({required this.debounceDuration});
  Timer? _debounceTimer;
  final Duration debounceDuration;

  void onButtonPressed(VoidCallback action) {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Start a new timer
    _debounceTimer = Timer(debounceDuration, action);
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
