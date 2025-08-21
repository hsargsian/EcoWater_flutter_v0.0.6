import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_picker_util.dart';
import 'ios_date_picker_view.dart';

enum DatePickerType { date, time, dateTime }

class DatePicker {
  DatePicker._();

  static Future<void> showDatePickerView(BuildContext context,
      {required DateTime initialDate,
      required DateTime minimumDate,
      required DateTime maximumDate,
      required DatePickerType type,
      Function(DateTime)? onDatePicked,
      bool? usesAndroidPicker}) async {
    final showAndroidPicker = usesAndroidPicker ?? false;
    if (DatePickerUtil.isAndroid() || showAndroidPicker) {
      if (type == DatePickerType.date) {
        final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: minimumDate,
            lastDate: maximumDate);
        if (pickedDate != null) {
          onDatePicked?.call(pickedDate);
        }
      } else if (type == DatePickerType.dateTime) {
        final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: minimumDate,
            lastDate: maximumDate);
        if (pickedDate != null) {
          if (!context.mounted) {
            return;
          }
          final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(initialDate));
          if (pickedTime != null) {
            onDatePicked?.call(DateTime(pickedDate.year, pickedDate.month,
                pickedDate.day, pickedTime.hour, pickedTime.minute));
          }
        }
      } else {
        final pickedTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
        if (pickedTime != null) {
          final now = DateTime.now();
          onDatePicked?.call(DateTime(now.year, now.month, now.day,
              pickedTime.hour, pickedTime.minute));
        }
      }
    } else {
      await showCupertinoModalPopup(
          context: context,
          builder: (_) => IOSDatePickerView(
                mode: (type == DatePickerType.date)
                    ? CupertinoDatePickerMode.date
                    : ((type == DatePickerType.dateTime)
                        ? CupertinoDatePickerMode.dateAndTime
                        : CupertinoDatePickerMode.time),
                initialDateTime: initialDate,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDatePicked: (datePicked) {
                  if (datePicked != null) {
                    onDatePicked?.call(datePicked);
                  }
                },
              ));
    }
  }
}
