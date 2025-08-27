import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/utils/crc_utils.dart';

enum FlaskOption {
  connect,
  personalizeFlask,
  startCycle,
  stopCycle,
  cleanFlask,
  sendTime,
  requestBatch,
  clearDataLog;

  String get title {
    switch (this) {
      case FlaskOption.connect:
        return 'Flask_option_connect_flask'.localized;
      case FlaskOption.personalizeFlask:
        return 'Flask_option_personalize_flask'.localized;
      case FlaskOption.startCycle:
        return 'Flask_option_start_cycle_flask'.localized;
      case FlaskOption.stopCycle:
        return 'Flask_option_stop_cycle_flask'.localized;
      case FlaskOption.cleanFlask:
        return 'Flask_option_clean_flask'.localized;
      case FlaskOption.sendTime:
        return 'Send Internet Based Time';
      case FlaskOption.requestBatch:
        return 'Request Batch';
      case FlaskOption.clearDataLog:
        return 'Clear Data Log';
    }
  }

  Widget? icon({required BuildContext context}) {
    final colorFilter = ColorFilter.mode(
        Theme.of(context).colorScheme.primaryElementColor, BlendMode.srcIn);
    const iconSize = 25.0;
    switch (this) {
      case FlaskOption.connect:
        return Icon(
          Icons.bluetooth,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case FlaskOption.personalizeFlask:
        return SvgPicture.asset(
          Images.flaskOptionPersonalizeFlask,
          colorFilter: colorFilter,
          height: iconSize,
        );
      case FlaskOption.startCycle:
        return SvgPicture.asset(
          Images.flaskOptionPersonalizeFlask,
          colorFilter: colorFilter,
          height: iconSize,
        );
      case FlaskOption.stopCycle:
        return SvgPicture.asset(
          Images.flaskOptionPersonalizeFlask,
          colorFilter: colorFilter,
          height: iconSize,
        );
      case FlaskOption.cleanFlask:
        return SvgPicture.asset(
          Images.flaskOptionCleanFlask,
          colorFilter: colorFilter,
          height: iconSize,
        );
      case FlaskOption.sendTime:
        return SvgPicture.asset(
          Images.flaskOptionCleanFlask,
          colorFilter: colorFilter,
          height: iconSize,
        );
      case FlaskOption.requestBatch:
        return Icon(
          Icons.request_quote,
          size: iconSize,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
      case FlaskOption.clearDataLog:
        return Icon(
          Icons.clear,
          size: iconSize,
          color: Theme.of(context).colorScheme.primaryElementColor,
        );
    }
  }
}

enum FlaskCommand {
  startCycle, //Done
  stopCycle, //Done
  cleanFlask, //Done
  colorChange, //Done
  changeLightMode, //Done
  changeDarkMode, //Done
  updateVolume, //Done
  wakeFromSleep, //Done
  updateName, //Done
  updateFlaskGoal,
  updateH2Goal,
  updateStreakGoal,
  updateInternetBasedTime,
  wakeUp,
  requestBatchLog,
  clearDataLog;

  List<int> get commandData {
    switch (this) {
      case FlaskCommand.startCycle:
        return [0xAA, 0x55, 0x03, 0x01, 0x01];
      case FlaskCommand.stopCycle:
        return [0xAA, 0x55, 0x03, 0x01, 0x02];
      case FlaskCommand.cleanFlask:
        return [0xAA, 0x55, 0x03, 0x02, 0x01];
      case FlaskCommand.colorChange:
        return [0xAA, 0x55, 0x05, 0x03];
      case FlaskCommand.updateVolume:
        return [0xAA, 0x55, 0x03, 0x04];
      case FlaskCommand.changeLightMode:
        return [0xAA, 0x55, 0x03, 0x05, 0x01];
      case FlaskCommand.changeDarkMode:
        return [0xAA, 0x55, 0x03, 0x05, 0x02];
      case FlaskCommand.wakeFromSleep:
        return [0xAA, 0x55, 0x03, 0x06];
      case FlaskCommand.updateName:
        return [0xAA, 0x55, 0x03, 0x06];
      case FlaskCommand.updateFlaskGoal:
        return [0xAA, 0x55, 0x03, 0x07];
      case FlaskCommand.updateH2Goal:
        return [0xAA, 0x55, 0x03, 0x08];
      case FlaskCommand.updateStreakGoal:
        return [0xAA, 0x55, 0x03, 0x09];
      case FlaskCommand.updateInternetBasedTime:
        return [0xAA, 0x55];
      case FlaskCommand.wakeUp:
        return [0xAA, 0x55];
      case FlaskCommand.requestBatchLog:
        return [];
      case FlaskCommand.clearDataLog:
        return [0xAA, 0x55, 0x05, 0x40, 0x12, 0x30, 0x98];
    }
  }
}

extension CommandDataExtensions on List<int> {
  List<int> addingCRC() {
    final crc = CRCUtils().getCRC(this);
    return [...this, crc];
  }

  List<int> addingUnixTime() {
    final command = <int>[0x0A];

    final localTime = DateTime.now();
    final timestamp = (localTime.millisecondsSinceEpoch ~/ 1000) +
        ((localTime.timeZoneOffset.inHours) * 3600);

    // Convert to 4-byte array (Big-Endian)
    final timeData = [
      (timestamp >> 24) & 0xFF,
      (timestamp >> 16) & 0xFF,
      (timestamp >> 8) & 0xFF,
      timestamp & 0xFF,
    ];
    final dataLength = command.length + timeData.length + 1;
    return this + [dataLength] + command + timeData;
  }

  DateTime toDateTime({bool isUtc = true}) {
    final timestamp =
        (this[0] << 24) | (this[1] << 16) | (this[2] << 8) | this[3];
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: isUtc);
  }
}

// Convert class to a utility function
List<int> buildDataPacket(DateTime startDate, DateTime endDate) {
  const head1 = 0xaa;
  const head2 = 0x55;
  const command = 0x31;

  final packet = [head1, head2, 0x0A, command];

  final startTimestamp = startDate.millisecondsSinceEpoch ~/ 1000;
  final endTimestamp = endDate.millisecondsSinceEpoch ~/ 1000;
  final startChunk = _intToBytes(startTimestamp);
  final endChunk = _intToBytes(endTimestamp);
  packet
    ..addAll(startChunk)
    ..addAll(endChunk);

  return packet.addingCRC();
}

List<int> _intToBytes(int value) => [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
