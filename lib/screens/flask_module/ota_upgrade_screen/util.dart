import 'dart:async';

import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

const defaultShadow = [
  BoxShadow(
      color: Color.fromRGBO(51, 51, 51, 0.08),
      offset: Offset(0, 1),
      blurRadius: 15)
];

typedef OnListener = void Function();
typedef OnBoolListener = void Function(bool b);
typedef OnUint8ListListener = void Function(Uint8List buffer);
typedef OnScanResultListener = void Function(ScanResult result);

bool isEmpty(String? text) {
  return text == null || text.isEmpty;
}

void delay(int time, OnListener listener) {
  // await Future.delayed(const Duration(seconds: 15));
  Timer(Duration(milliseconds: time), listener);
}

void showToast(BuildContext context, String msg,
    {SnackbarStyle style = SnackbarStyle.error}) {
  Utilities.showSnackBar(context, msg, style);
}

class Util {
  Util._();
  static int _startTime = 0;
  static int _maxLen = 500;

  static bool canExitApp(BuildContext context) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _startTime >= 2000) {
      showToast(context, 'Can not exist the app at the moment');
      _startTime = now;
      return false;
    } else {
      return true;
    }
  }

  static int _debounceStartTime = 0;
  static const int _debounceMs = 1000;

  static bool debounce() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _debounceStartTime >= _debounceMs) {
      _debounceStartTime = now;
      return false;
    } else {
      return true;
    }
  }

  static void v(Object? object, {String? tag}) {
    _printLog(tag, ' v ', object);
  }

  static void _printLog(String? tag, String stag, Object? object) {
    var da = object?.toString() ?? 'null';
    tag = tag ?? 'logmsg';
    if (da.length <= _maxLen) {
      log('$tag$stag $da');
      return;
    }
    log('$tag$stag — — — — — — — — — — — — — — — — st — — — — — — — — — — — — — — — —');
    while (da.isNotEmpty) {
      if (da.length > _maxLen) {
        log('$tag$stag| ${da.substring(0, _maxLen)}');
        da = da.substring(_maxLen, da.length);
      } else {
        log('$tag$stag| $da');
        da = '';
      }
    }
    log('$tag$stag — — — — — — — — — — — — — — — — ed — — — — — — — — — — — — — — — —');
  }

  static void log(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }

  static List<String> getHexString(List<int> list) {
    final res = <String>[];
    for (var i = 0; i < list.length; i++) {
      final hex = list[i].toRadixString(16);
      if (hex.length == 1) {
        res.add('0$hex');
      } else {
        res.add(hex);
      }
    }
    return res;
  }

  static Uint8List hex4ToUint8List(String hex) {
    final hex4 = hex.replaceAll(' ', '').padLeft(8, '0');
    if (hex4.length != 8) {
      return Uint8List(0);
    }
    final byteCount = hex4.length ~/ 2;
    final result = Uint8List(byteCount);
    for (var i = 0; i < byteCount; i++) {
      final byteValue =
          int.parse(hex4.substring(i * 2, (i + 1) * 2), radix: 16);
      result[i] = byteValue;
    }
    return result;
  }

  static bool areUint8ListsEqual(Uint8List list1, Uint8List list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (var i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        print("list1[i]: ${list1[i]}");
        print("list2[i]: ${list2[i]}");
        return false;
      }
    }
    return true;
  }

  static Uint8List insert00(Uint8List data) {
    if (data.length < 4) {
      return data;
    }
    final successData = Uint8List(data.length + 1);
    for (var i = 0; i < data.length - 3; i++) {
      successData[i] = data[i];
    }
    successData[data.length - 3] = 0;
    for (var i = data.length - 3; i < data.length; i++) {
      successData[i + 1] = data[i];
    }
    return successData;
  }
}
