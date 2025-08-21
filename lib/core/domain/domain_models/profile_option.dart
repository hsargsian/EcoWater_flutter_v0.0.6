import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum ProfileOption {
  devices,
  notifications,
  changePassword,
  notificationSettings,
  emailSettings,
  integration,
  tooltip,
  onboarding,
  logout,
  deleteAccount,
  bleUUIds;

  static List<ProfileOption> options() {
    if (kDebugMode) {
      return ProfileOption.values;
    } else {
      return [
        ProfileOption.devices,
        ProfileOption.notifications,
        ProfileOption.changePassword,
        ProfileOption.notificationSettings,
        ProfileOption.emailSettings,
        ProfileOption.integration,
        ProfileOption.tooltip,
        ProfileOption.onboarding,
        ProfileOption.logout,
        ProfileOption.deleteAccount
      ];
    }
  }

  String get title {
    switch (this) {
      case ProfileOption.devices:
        return 'profileOption_devices'.localized;
      case ProfileOption.notifications:
        return 'profileOption_notifications'.localized;
      case ProfileOption.notificationSettings:
        return 'profileOption_notificationSettings'.localized;
      case ProfileOption.emailSettings:
        return 'profileOption_emailSettings'.localized;
      case ProfileOption.integration:
        return 'profileOption_integrationSettings'.localized;
      case ProfileOption.tooltip:
        return 'profileOption_tooltipSettings'.localized;
      case ProfileOption.changePassword:
        return 'profileOption_changePassword'.localized;
      case ProfileOption.deleteAccount:
        return 'profileOption_deleteAccount'.localized;
      case ProfileOption.logout:
        return 'profileOption_logout'.localized;
      case ProfileOption.onboarding:
        return 'profileOption_onboarding'.localized;
      case ProfileOption.bleUUIds:
        return 'BLE Configurator'.localized;
    }
  }

  Color getTitleColor(BuildContext context) {
    switch (this) {
      case ProfileOption.devices:
      case ProfileOption.notifications:
      case ProfileOption.notificationSettings:
      case ProfileOption.emailSettings:
      case ProfileOption.integration:
      case ProfileOption.tooltip:
      case ProfileOption.changePassword:
      case ProfileOption.onboarding:
      case ProfileOption.bleUUIds:
        return Theme.of(context).colorScheme.primaryElementColor;
      case ProfileOption.deleteAccount:
      case ProfileOption.logout:
        return Theme.of(context).colorScheme.appRed;
    }
  }

  Widget getIcon(BuildContext context) {
    switch (this) {
      case ProfileOption.devices:
        return SvgPicture.asset(
          Images.bluetoothDeviceIcon,
          width: 30,
        );
      case ProfileOption.notifications:
        return SvgPicture.asset(
          Images.notificationSettingIcon,
          width: 30,
        );
      case ProfileOption.notificationSettings:
        return Icon(
          Icons.settings,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.emailSettings:
        return Icon(
          Icons.email,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.integration:
        return Icon(
          Icons.integration_instructions,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.tooltip:
        return Icon(
          Icons.integration_instructions,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.onboarding:
        return Icon(
          Icons.info,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.changePassword:
        return Icon(
          Icons.lock,
          size: 20,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case ProfileOption.deleteAccount:
        return Icon(
          Icons.delete_forever,
          size: 25,
          color: Theme.of(context).colorScheme.appRed,
        );
      case ProfileOption.logout:
        return Icon(
          Icons.logout,
          size: 25,
          color: Theme.of(context).colorScheme.appRed,
        );
      case ProfileOption.bleUUIds:
        return Icon(
          Icons.bluetooth_connected,
          size: 25,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
    }
  }
}
