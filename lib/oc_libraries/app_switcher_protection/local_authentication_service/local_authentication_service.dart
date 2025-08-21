import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  LocalAuthenticationService() {
    init();
  }
  final LocalAuthentication auth = LocalAuthentication();
  bool _canAuthenticateWithBiometrics = false;
  bool _canAuthenticate = false;
  DateTime? _lastAuthTime;

  Function()? evictLoggedInUser;

  bool needsLocalAuth = false;

  Future<void> init() async {
    _canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    _canAuthenticate =
        _canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    if (!needsLocalAuth) {
      return true;
    }
    if (!_canAuthenticate) {
      return true;
    }

    if (_lastAuthTime == null) {
      _lastAuthTime = DateTime.now();
    } else {
      if (DateTime.now().difference(_lastAuthTime!).inSeconds < 100) {
        return true;
      }
    }

    try {
      _lastAuthTime = DateTime.now();
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate...',
      );
      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  void ejectLoggedInUser() {
    needsLocalAuth = false;
    evictLoggedInUser?.call();
  }
}
