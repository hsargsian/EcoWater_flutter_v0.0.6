enum UserType {
  normal;

  String get key {
    switch (this) {
      case UserType.normal:
        return 'normal';
    }
  }

  String get title {
    switch (this) {
      case UserType.normal:
        return 'Normal';
    }
  }
}
