enum AppTheme {
  dark,
  light,
  defaultTheme;

  String get key {
    switch (this) {
      case AppTheme.dark:
        return 'dark';
      case AppTheme.light:
        return 'light';
      case AppTheme.defaultTheme:
        return 'defaultTheme';
    }
  }
}

class AppThemeManager {
  factory AppThemeManager() {
    _instance ??= AppThemeManager._internal();
    return _instance!;
  }
  AppThemeManager._internal();
  static AppThemeManager? _instance;

  Function()? onThemeChange;

  AppTheme currentAppTheme = AppTheme.light;

  void changeTheme(AppTheme theme) {
    if (theme != currentAppTheme) {
      currentAppTheme = theme;
      onThemeChange?.call();
    }
  }
}
