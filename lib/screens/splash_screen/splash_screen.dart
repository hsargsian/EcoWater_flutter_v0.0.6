import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/utils/images.dart';
import '../../core/injector/injector.dart';
import '../auth/authentication/bloc/authentication_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({this.isCallInitState = true, super.key});

  final bool isCallInitState;

  @override
  State<SplashPage> createState() => _SplashPageState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/SplashPage'),
        builder: (_) => const SplashPage());
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isCallInitState) {
      _checkIfUserSessionExists();
    }
  }

  void _checkIfUserSessionExists() {
    Future.delayed(const Duration(seconds: 2), () {
      Injector.instance<AuthenticationBloc>()
          .add(AuthenticationCheckUserSessionEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.navBarLogo,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        ],
      ),
    );
  }
}
