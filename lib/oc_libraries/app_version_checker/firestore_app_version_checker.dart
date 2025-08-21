import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_version_checker.dart';
import 'app_version_update_model.dart';

class FirestoreAppVersionChecker extends AppVersionChecker {
  FirestoreAppVersionChecker(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<AppVersionUpdateModel?> isUpdateRequired(
      String currentVersion, String platform) async {
    final latestVersion = await getLatestVersion();
    if (latestVersion == null) {
      return null;
    }
    final isIos = platform == 'ios';
    final appVersionFromRemote =
        latestVersion[isIos ? 'ios-version' : 'android-version'];
    final appVersionRemoteArray =
        appVersionFromRemote.split('.').map(int.parse).toList();
    final appVersionLocalArray =
        currentVersion.split('.').map(int.parse).toList();
    var needsUpdate = false;
    if (appVersionRemoteArray[0] > appVersionLocalArray[0]) {
      needsUpdate = true;
    } else {
      if (appVersionRemoteArray[1] > appVersionLocalArray[1]) {
        needsUpdate = true;
      } else {
        if (appVersionRemoteArray[1] != appVersionLocalArray[1]) {
          needsUpdate = true;
        }
        if (appVersionRemoteArray[2] > appVersionLocalArray[2]) {
          needsUpdate = true;
        }
      }
    }
    return needsUpdate
        ? AppVersionUpdateModel(
            message: latestVersion['message'],
            isMandatoryUpdate:
                latestVersion[isIos ? 'ios-mandatory' : 'android-mandatory'],
            storeLink:
                latestVersion[isIos ? 'ios-store-link' : 'android-store-link'])
        : null;
  }

  @override
  Future<Map<String, dynamic>?> getLatestVersion() async {
    final versionDoc =
        await firestore.collection('appversions').doc('version').get();
    return versionDoc.data();
  }
}
