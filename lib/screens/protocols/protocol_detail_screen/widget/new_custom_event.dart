import 'package:echowater/screens/protocols/protocol_detail_screen/widget/title_custom_dropdown_button.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../base/common_widgets/buttons/app_button.dart';
import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../base/constants/string_constants.dart';
import '../../../../base/utils/colors.dart';
import '../../../../base/utils/utilities.dart';
import '../../../../core/domain/entities/event_entity.dart';
import 'repeat_custom_dropdown_button.dart';

class NewCustomEvent extends StatefulWidget {
  const NewCustomEvent({required this.dateTime, required this.onSave, super.key});

  final DateTime dateTime;
  final Function(EventEntity model) onSave;

  @override
  State<NewCustomEvent> createState() => _NewCustomEventState();
}

class _NewCustomEventState extends State<NewCustomEvent> {
  late ValueNotifier<DateTime> _startDateTimeNotifier;
  late ValueNotifier<DateTime> _endDateTimeNotifier;
  String? _selectedTitle;
  String? repeat;

  @override
  void initState() {
    _startDateTimeNotifier = ValueNotifier<DateTime>(widget.dateTime);
    _endDateTimeNotifier = ValueNotifier<DateTime>(widget.dateTime.add(const Duration(hours: 1)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryElementColor,
              height: 3,
              width: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text('New Event',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontFamily: StringConstants.fieldGothicFont, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 12,
            ),
            TitleCustomDropdownButton(
              items: const ['Sleep Time', 'Workout', 'Drink H2 Water'],
              selectTitle: (value) {
                _selectedTitle = value;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Schedule Time',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder<DateTime>(
                valueListenable: _startDateTimeNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Time'),
                      InkWell(
                        onTap: () {
                          _openTimePicker(context, value, true);
                        },
                        child: Text(
                          DateFormat('hh:mm a').format(value),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondaryElementColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
                valueListenable: _endDateTimeNotifier,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('End Time'),
                      InkWell(
                        onTap: () {
                          _openTimePicker(context, value, false);
                        },
                        child: Text(
                          DateFormat('hh:mm a').format(value),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondaryElementColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            RepeatCustomDropdownButton(
              selectedRepeat: (value) {
                repeat = value;
              },
            ),
            AppButton(
                title: 'Save',
                height: 45,
                radius: 22.5,
                hasGradientBackground: true,
                onClick: () {
                  if (_endDateTimeNotifier.value.hour == 12) {
                    _endDateTimeNotifier.value = DateTime(_endDateTimeNotifier.value.year, _endDateTimeNotifier.value.month,
                        _endDateTimeNotifier.value.day, _endDateTimeNotifier.value.hour - 1, 59, 59);
                  }

                  if (_selectedTitle == null || _selectedTitle!.isEmpty) {
                    Utilities.showSnackBar(context, 'Please choose the event name', SnackbarStyle.error);
                  } else if (_endDateTimeNotifier.value.difference(_startDateTimeNotifier.value).inMinutes < 30) {
                    Utilities.showSnackBar(context, 'The time difference must be at least 30 minutes', SnackbarStyle.error);
                  }
                  // else if (_startDateTimeNotifier.value.isAfter(_endDateTimeNotifier.value)) {
                  //   Utilities.showSnackBar(context, 'Start time cannot be after end time', SnackbarStyle.error);
                  // }
                  else {
                    widget.onSave(EventEntity(
                        id: null,
                        title: _selectedTitle ?? '',
                        startTime: _startDateTimeNotifier.value,
                        endTime: _endDateTimeNotifier.value,
                        repeat: repeat ?? ''));
                    Navigator.pop(context);
                  }
                }),
            const SizedBox(
              height: 12,
            ),
            AppButton(
                title: 'Cancel',
                height: 45,
                radius: 22.5,
                elevation: 0,
                backgroundColor: AppColors.black,
                border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
                onClick: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _openTimePicker(BuildContext context, DateTime dateTime, bool isStartTime) async {
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.black)),
            child: child!,
          );
        });
    if (pickedTime != null) {
      if (isStartTime) {
        _startDateTimeNotifier.value = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
      } else {
        _endDateTimeNotifier.value = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
      }
    }
  }
}
