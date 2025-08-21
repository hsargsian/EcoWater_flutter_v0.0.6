import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'accessory_bar.dart';

class IOSDatePickerView extends StatefulWidget {
  const IOSDatePickerView(
      {required this.mode,
      super.key,
      this.onDatePicked,
      this.initialDateTime,
      this.minimumDate,
      this.maximumDate});
  final Function(DateTime?)? onDatePicked;
  final CupertinoDatePickerMode mode;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<IOSDatePickerView> createState() => _IOSDatePickerViewState();
}

class _IOSDatePickerViewState extends State<IOSDatePickerView> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 230,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            DatePickerAccessoryBar(
              onCancelPressed: () {
                Navigator.pop(context);
              },
              doneText: 'Done',
              onDonePressed: () {
                widget.onDatePicked?.call(selectedDateTime);
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                  mode: widget.mode,
                  initialDateTime: widget.initialDateTime,
                  maximumDate: widget.maximumDate,
                  minimumDate: widget.minimumDate,
                  onDateTimeChanged: (val) {
                    selectedDateTime = val;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
