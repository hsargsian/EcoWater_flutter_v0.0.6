class AppVersionUpdateModel {
  AppVersionUpdateModel(
      {required this.message,
      required this.isMandatoryUpdate,
      required this.storeLink});
  final String message;
  final bool isMandatoryUpdate;
  final String storeLink;
}
