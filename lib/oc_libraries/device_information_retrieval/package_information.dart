class PackageInformation {
  PackageInformation(
      {required this.appName,
      required this.packageName,
      required this.versionName,
      required this.buildNumber});
  final String appName;
  final String packageName;
  final String versionName;
  final String buildNumber;

  Map<String, dynamic> toJson() {
    return {
      'App Name': appName,
      'Package Name': packageName,
      'Version Name': versionName,
      'Build Number': buildNumber
    };
  }
}
