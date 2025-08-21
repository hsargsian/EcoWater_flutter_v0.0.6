import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // some base colors
  static const transparent = Colors.transparent;
  static const white = Colors.white;
  static const black = Colors.black;
  static const gray = Colors.grey;
  // app specifc colors.. there are usually 3 different sets of colors in app

  static const primaryDark = Color(0xff00A7B5);
  static const primaryLight = Color(0xff00A7B5);

  static const mainBackgroundColorDark = Color(0xff141318);
  static const mainBackgroundColorLight = Color(0xff141318);

  static const secondaryBackgroundColorDark = Color(0xff28272C);
  static const secondaryBackgroundColorLight = Color(0xff28272C);

  static const tertiaryBackgroundColorDark = Color(0xff464646);
  static const tertiaryBackgroundColorLight = Color(0xff464646);

  static const primaryElementColorLight = Colors.black;
  static const primaryElementColorDark = Colors.white;

  static const primaryHighlightColorLight = Color(0xff7C6992);
  static const primaryHighlightColorDark = Color(0xff7C6992);

  static const secondaryElementColorLight = Color(0xff9F9F9F);
  static const secondaryElementColorDark = Color(0xff9F9F9F);

  static const primaryElementInvertedColor = Color(0xffAAADB1); // main white
  static const secondaryElementColor = Color(0xff1F2122);
  static const tertiaryElementColor = Color(0xff989BA2);
  static const accentElementColor = Color(0xff8E8E8E); // other greyesh

  static const redColor = Color(0xffD31510);
  static const errorRedColor = Colors.red;
  static const green = Color(0xff00B348);
  static const fieldBackgroundColor = Color(0xffF3F5F6);
  static const separatorColor = Color(0XFFF7F7F7);
  static const colorD9D9D9 = Color(0xffD9D9D9);
  static const colorB3B3B3 = Color(0xffb3b3b3);
  static const colorC4C4C4 = Color(0xffC4C4C4);
  static const colorD8D8D8 = Color(0xffD8D8D8);
  static const colorC4A6B5 = Color(0xffC4A6B5);
  static const colorC3A2B3 = Color(0xffC3A2B3);
  static const color437986 = Color(0xff437986);
  static const color59585E = Color(0xff59585E);
  static const color231F20 = Color(0xff231F20);

  static Color bottomsheetBarrierColor = AppColors.black.withValues(alpha: 0.5);
  static Color walkthroughBarrierColor = AppColors.black.withValues(alpha: 0.3);
  static Color color717171Base = const Color(0xff717171);
  static Color color717171 = const Color(0xff717171).withValues(alpha: 0.3);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to
  /// `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${a.toInt().toRadixString(16).padLeft(2, '0')}'
      '${r.toInt().toRadixString(16).padLeft(2, '0')}'
      '${g.toInt().toRadixString(16).padLeft(2, '0')}'
      '${b.toInt().toRadixString(16).padLeft(2, '0')}';

  static Color averageColorFromGradient(List<String> hexColors) {
    var totalRed = 0;
    var totalGreen = 0;
    var totalBlue = 0;

    for (final hex in hexColors) {
      final color = HexColor.fromHex(hex);
      totalRed += color.red.toInt();
      totalGreen += color.green.toInt();
      totalBlue += color.blue.toInt();
    }

    final count = hexColors.length;
    return Color.fromARGB(
        255, totalRed ~/ count, totalGreen ~/ count, totalBlue ~/ count);
  }
}
