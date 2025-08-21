import 'package:echowater/base/utils/iterable.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../base/app_specific_widgets/animating_pulse_lottie_view.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/utils/animations.dart';
import '../../../core/injector/injector.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';

class NoDevicesFoundView extends StatelessWidget {
  const NoDevicesFoundView(
      {required this.title, this.onSearchAgainClick, super.key});
  final Function()? onSearchAgainClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatingPulseLottieView(
            path: Animations.grayAnimation,
            text: title,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'NoDeviceFoundView_Make_sure_that'.localized,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
              children: [
            'NoDeviceFoundView_Bluetooth_is_activated'.localized,
            'NoDeviceFoundView_on_and_in_pairing'.localized,
            'NoDeviceFoundView_Both_devices_are_nearby'.localized
          ].enumerate().map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text('${entry.key + 1}. ${entry.value}',
                  style: Theme.of(context).textTheme.bodySmall),
            );
          }).toList()),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AppButton(
              title: 'NoDeviceFoundView_Search_Again'.localized,
              onClick: onSearchAgainClick,
              hasGradientBackground: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Injector.instance<AuthenticationBloc>()
                  .add(AuthenticationCheckUserSessionEvent());
            },
            child: Text(
              'skip'.localized,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        ],
      ),
    );
  }
}
