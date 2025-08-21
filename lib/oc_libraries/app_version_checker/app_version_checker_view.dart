import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../device_information_retrieval/device_information_retrieval_service.dart';
import '../device_information_retrieval/device_information_retrieval_service_impl.dart';
import 'app_version_checker.dart';
import 'app_version_update_model.dart';
import 'firestore_app_version_checker.dart';

class AppVersionCheckerView extends StatefulWidget {
  const AppVersionCheckerView(
      {required this.child, required this.textColor, super.key});
  final Widget child;
  final Color textColor;

  @override
  State<AppVersionCheckerView> createState() => _AppVersionCheckerViewState();
}

class _AppVersionCheckerViewState extends State<AppVersionCheckerView>
    with WidgetsBindingObserver {
  final AppVersionChecker _appVersionChecker =
      FirestoreAppVersionChecker(FirebaseFirestore.instance);

  AppVersionUpdateModel? _appVersionUpdateModel;
  bool _isInitialized = false;
  late final DeviceInformationRetrievalService _deviceInfoService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initService();
  }

  Future<void> _initService() async {
    _deviceInfoService = await DeviceInformationRetrievalServiceImpl.init();
    _isInitialized = true;
    await _checkAppVersion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAppVersion();
    }
  }

  Future<void> _checkAppVersion() async {
    if (!_isInitialized) {
      assert(false, 'The version checker is not initialized');
    }
    final packageInfromation =
        await _deviceInfoService.fetchPackageInformation();
    final deviceInfromation = await _deviceInfoService.fetchDeviceInformation();
    final versionInfo = await _appVersionChecker.isUpdateRequired(
        packageInfromation.versionName, deviceInfromation.platform);
    _appVersionUpdateModel = versionInfo;
    setState(() {});
  }

  Widget _appUpdateView() {
    final versionInfo = _appVersionUpdateModel;
    if (versionInfo == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.height * 0.7,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          'App Update',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: widget.textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20),
                        child: Text(
                          versionInfo.message,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: widget.textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          height: 45,
                          minWidth: 200,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            launchUrlString(versionInfo.storeLink);
                          },
                          child: const Text(
                            'Update App',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [widget.child, _appUpdateView()],
    );
  }
}
