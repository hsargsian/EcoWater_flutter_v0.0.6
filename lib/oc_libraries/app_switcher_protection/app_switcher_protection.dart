import 'package:flutter/material.dart';

import 'local_authentication_service/local_authentication_service.dart';
import 'secure_overlay.dart';

class AppSwitcherProtection extends StatefulWidget {
  const AppSwitcherProtection(
      {required this.child,
      required this.usesBiometricAuthentication,
      required this.hasAppShield,
      required this.evictLoggedInUser,
      this.switcherWidget,
      this.maxNotMatchCountLimit,
      super.key});
  final Widget child;
  final bool usesBiometricAuthentication;
  final Widget? switcherWidget;
  final bool hasAppShield;
  final int? maxNotMatchCountLimit;
  final Function() evictLoggedInUser;

  @override
  AppSwitcherProtectionState createState() => AppSwitcherProtectionState();
}

class AppSwitcherProtectionState extends State<AppSwitcherProtection>
    with WidgetsBindingObserver {
  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;
  bool _showsSecureOverlay = false;

  int _notMatchingCount = 0;

  var _maxNotMatchCountLimit = 3;
  final _localAuthService = LocalAuthenticationService();
  @override
  void initState() {
    _maxNotMatchCountLimit = widget.maxNotMatchCountLimit ?? 3;
    _localAuthService.needsLocalAuth = widget.usesBiometricAuthentication;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSecureOverlay();
    _localAuthService.evictLoggedInUser = () {
      widget.evictLoggedInUser.call();
    };
  }

  void updateProtectionState({required bool needsAuth}) {
    _localAuthService.needsLocalAuth = needsAuth;
  }

  void _updateSecureOverlay() {
    _showsSecureOverlay =
        widget.hasAppShield && _lifecycleState != AppLifecycleState.resumed;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      if (widget.usesBiometricAuthentication) {
        _initiateAuthenticationProcess();
      } else {
        _updateSecureOverlay();
      }
    } else {
      _updateSecureOverlay();
    }
  }

  Future<void> _initiateAuthenticationProcess() async {
    final didAuthenticate = await _localAuthService.authenticate();
    if (didAuthenticate) {
      _notMatchingCount = 0;
      _updateSecureOverlay();
    } else {
      _notMatchingCount += 1;
      if (_notMatchingCount == _maxNotMatchCountLimit) {
        _notMatchingCount = 0;
        _localAuthService.ejectLoggedInUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
            visible: _showsSecureOverlay,
            child: SecureOverlay(
              switcherWidget: widget.switcherWidget,
            ))
      ],
    );
  }
}
