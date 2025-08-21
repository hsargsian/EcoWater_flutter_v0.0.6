import 'dart:io';
import 'dart:math';

import 'package:echowater/base/common_widgets/alert/alert.dart';
import 'package:echowater/base/utils/pair.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/services/bluetooth_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';

import '../common_widgets/snackbar/snackbar_content.dart';
import '../common_widgets/snackbar/snackbar_style.dart';
import '../constants/constants.dart';
import 'colors.dart';

// ignore: avoid_classes_with_only_static_members
class Utilities {
  static void printObj(Object message) {
    if (kDebugMode) {
      Logger.root.info(message);
    }
  }

  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void showSnackBar(
      BuildContext context, String message, SnackbarStyle style,
      {Widget? dynamicContent, Color? dynamicBackgroundColor}) {
    if (message.isEmpty && dynamicContent == null) {
      return;
    }
    _showOverlay(context,
        text: message,
        style: style,
        dynamicContent: dynamicContent,
        dynamicBackgroundColor: dynamicBackgroundColor);
  }

  static Future<void> _showOverlay(BuildContext context,
      {required String text,
      required SnackbarStyle style,
      Widget? dynamicContent,
      Color? dynamicBackgroundColor}) async {
    final overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        left: 10,
        right: 10,
        bottom: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            child: SnackBarContent(
              message: text,
              style: style,
              dynamicContent: dynamicContent,
              dynamicBackgroundColor: dynamicBackgroundColor,
            ),
          ),
        ),
      );
    });
    // inserting overlay entry
    overlayState.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: Constants.snackbarDuration))
        // removing overlay entry after stipulated time.
        .whenComplete(() => overlayEntry.remove());
  }

  static void showBottomSheet({
    required Widget widget,
    required BuildContext context,
    Color? backgroundColor,
    bool isDismissable = true,
  }) {
    Utilities.vibrate();
    Utilities.dismissKeyboard();
    showModalBottomSheet(
        backgroundColor: AppColors.transparent,
        isDismissible: isDismissable,
        barrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        context: context,
        isScrollControlled: isDismissable,
        enableDrag: isDismissable,
        builder: (context) => widget);
  }

  static String generateRadomCode(int digitCount) {
    final random = Random();
    final code = random.nextInt(900000) + 100000;
    return code.toString();
  }

  static int generateRandomInt(int max) {
    final random = Random();
    return random.nextInt(max);
  }

  static bool hasAppUpdate(
      {required String existingVersion, required String remoteVersion}) {
    final existingVersionChunks =
        existingVersion.split('.').map(int.parse).toList();
    final remoteVersionChunks =
        remoteVersion.split('.').map(int.parse).toList();
    if ((existingVersionChunks.length != 3) ||
        (remoteVersionChunks.length != 3)) {
      return false;
    }
    if (remoteVersionChunks[0] > existingVersionChunks[0]) {
      return true;
    } else if (remoteVersionChunks[0] == existingVersionChunks[0]) {
      if (remoteVersionChunks[1] > existingVersionChunks[1]) {
        return true;
      } else if (remoteVersionChunks[1] == existingVersionChunks[1]) {
        if (remoteVersionChunks[2] > existingVersionChunks[2]) {
          return true;
        }
      }
    }
    return false;
  }

  static int toMiles(int meters) {
    return (meters * 0.000621371).toInt();
  }

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  static Future<void> vibrate() async {
    if (!Constants.hasVibrationEnabled) {
      return;
    }
    final hasVibration = (await Vibration.hasVibrator()) ?? false;
    if (hasVibration) {
      await Vibration.vibrate(duration: 5);
    }
    await HapticFeedback.lightImpact();
  }

  static String capitalizeEachWord(String input) {
    // Split the input string into individual words
    final words = input.split(' ');

    // Capitalize the first letter of each word
    final capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word; // Handle empty words if needed
      }
    }).toList();

    // Join the capitalized words back into a single string
    return capitalizedWords.join(' ');
  }

  static void bleLog(dynamic obj) {
    if (kDebugMode) {
      print('BLE Echo $obj');
    }
  }

  static void launchUrl(String url) {
    var mutableUrl = url;
    if (!(url.startsWith('https://') || url.startsWith('http://'))) {
      mutableUrl = 'https://$url';
    }
    launchUrlString(mutableUrl);
  }

  static Future<Pair<bool, String?>> checkBLEState(
      {BuildContext? context, bool showsAlert = false}) async {
    if (await FlutterBluePlus.isSupported == false) {
      return Pair(first: false, second: 'Bluetooth not supported'.localized);
    }

    final adapterState = await FlutterBluePlus.adapterState.first;

    if (adapterState == BluetoothAdapterState.off) {
      if (showsAlert && context != null && Platform.isIOS) {
        if (context.mounted) {
          Alert().showAlert(
              context: context,
              title: 'Bluetooth Permission Required',
              isWarningAlert: true,
              message: 'Bluetooth_turned_off_error_message'.localized,
              actionWidget: Alert().getDefaultTwoButtons(
                  context: context,
                  firstButtonTitle: 'Open Settings',
                  lastButtonTitle: 'Not Now',
                  onFirstButtonClick: () {
                    Navigator.pop(context);
                    BluetoothSettings.openBluetoothSettings();
                  },
                  onLastButtonClick: () {
                    Navigator.pop(context);
                  }));
        }
      }
      return Pair(
          first: false,
          second: showsAlert
              ? null
              : 'Bluetooth_turned_off_error_message'.localized);
    }
    if (Platform.isIOS) {
      final status = await Permission.bluetooth.status;
      if (status != PermissionStatus.granted) {
        if (showsAlert && context != null) {
          if (context.mounted) {
            Alert().showAlert(
                context: context,
                title: 'Bluetooth Permission Required',
                isWarningAlert: true,
                message: 'Bluetooth_turned_off_error_message'.localized,
                actionWidget: Alert().getDefaultTwoButtons(
                    context: context,
                    firstButtonTitle: 'Open Settings',
                    lastButtonTitle: 'Not Now',
                    onFirstButtonClick: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                    onLastButtonClick: () {
                      Navigator.pop(context);
                    }));
          }
        }
        return Pair(
            first: false,
            second: showsAlert
                ? null
                : 'Bluetooth_permission_denied_message'.localized);
      }
    }

    return Pair(first: true, second: null);
  }
}
