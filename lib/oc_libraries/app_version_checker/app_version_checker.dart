import 'app_version_update_model.dart';

abstract class AppVersionChecker {
  // Abstract method to check if app update is required
  Future<AppVersionUpdateModel?> isUpdateRequired(
      String currentVersion, String platform);

  // Abstract method to get latest app version
  Future<Map<String, dynamic>?> getLatestVersion();
}
