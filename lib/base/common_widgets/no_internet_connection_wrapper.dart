import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/images.dart';

class NoInternetConnectivityWrapper extends StatefulWidget {
  const NoInternetConnectivityWrapper({required this.child, super.key});

  final Widget child;

  @override
  _NoInternetConnectivityWrapperState createState() =>
      _NoInternetConnectivityWrapperState();
}

class _NoInternetConnectivityWrapperState
    extends State<NoInternetConnectivityWrapper> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool hasInternet = true;

  @override
  void initState() {
    _setNetworkConnectionValue(flag: false);
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      // Got a new connectivity status!
      Future.delayed(const Duration(seconds: 1), _setNetworkConnectionValue);
    });
    super.initState();
  }

  Future<void> _setNetworkConnectionValue({bool flag = true}) async {
    hasInternet = (await Connectivity().checkConnectivity()).first !=
        ConnectivityResult.none;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          Visibility(
              visible:
                  !hasInternet && Constants.showsInternetConnectivitySheild,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: (hasInternet && Constants.showsInternetConnectivitySheild)
                  ? -300
                  : 0,
              height: 300,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow:
                      !hasInternet && Constants.showsInternetConnectivitySheild
                          ? [
                              BoxShadow(
                                  offset: const Offset(0, 3),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  color: Colors.white.withValues(alpha: 0.2))
                            ]
                          : [],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                alignment: Alignment.bottomCenter,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Images.navBarLogo,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('No Internet Connection',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
