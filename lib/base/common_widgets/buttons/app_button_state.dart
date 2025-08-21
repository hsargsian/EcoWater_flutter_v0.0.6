/// Buttons are usually in all app in 3 different states
enum AppButtonState {
  enabled,
  tapped,
  disabled;

  double get opacity {
    switch (this) {
      case AppButtonState.enabled:
        return 1;
      case AppButtonState.tapped:
        return 0.7;
      case AppButtonState.disabled:
        return 0.3;
    }
  }
}
