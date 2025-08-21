class Refresher {
  factory Refresher() {
    return _instance;
  }
  Refresher._privateConstructor();

  static final Refresher _instance = Refresher._privateConstructor();

  Function()? refreshHomeScreen;
  Function()? refreshGoalScreen;
  Function()? refreshProfileScreen;
}
