import 'package:echowater/base/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/string_constants.dart';
import '../../utils/images.dart';

class CalendarHeaderView extends StatelessWidget {
  const CalendarHeaderView(
      {required this.calendarFormat,
      required this.focusedDate,
      required this.selectedDate,
      required this.onCalendarFormatChanged,
      required this.onFocusedDateChanged,
      required this.showsCalendarFormatChanger,
      this.maxPastDate,
      this.maxFutureDate,
      super.key});
  final CalendarFormat calendarFormat;
  final DateTime focusedDate;
  final DateTime selectedDate;
  final Function(CalendarFormat)? onCalendarFormatChanged;
  final Function(DateTime date)? onFocusedDateChanged;
  final DateTime? maxPastDate;
  final DateTime? maxFutureDate;
  final bool showsCalendarFormatChanger;

  @override
  Widget build(BuildContext context) {
    return _headerView(context);
  }

  Widget _headerView(BuildContext context) {
    return calendarFormat == CalendarFormat.month
        ? _monthHeaderView(context)
        : _weekHeaderView(context);
  }

  Widget _weekHeaderView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMM yyyy').format(focusedDate),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: StringConstants.fieldGothicTestFont),
          ),
          Row(
            children: [
              IconButton(
                  onPressed:
                      _canPressPastButton() ? _onPreviousButtonPressed : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white
                        .withValues(alpha: _canPressPastButton() ? 1.0 : 0.3),
                  )),
              Text(
                '${DateFormat('EEE. dd').format(_startDateOf(focusedDate))} - ${DateFormat('EEE. dd').format(_endDateOf(focusedDate))}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.5)),
              ),
              IconButton(
                  onPressed:
                      _canPressNextButton() ? _onNextButtonPressed : null,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white
                        .withValues(alpha: _canPressNextButton() ? 1.0 : 0.3),
                  )),
            ],
          ),
          showsCalendarFormatChanger
              ? InkWell(
                  onTap: () {
                    onCalendarFormatChanged?.call(CalendarFormat.month);
                  },
                  child: SvgPicture.asset(
                    Images.calendarIcon,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ))
              : const SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }

  void _onNextButtonPressed() {
    var tempFocusedDate = focusedDate;
    if (calendarFormat == CalendarFormat.month) {
      if (selectedDate.month == 12) {
        tempFocusedDate = DateTime(focusedDate.year + 1);
      } else {
        tempFocusedDate = DateTime(focusedDate.year, focusedDate.month + 1);
      }
    } else {
      tempFocusedDate = focusedDate.add(const Duration(days: 7));
    }

    onFocusedDateChanged?.call(tempFocusedDate);
  }

  void _onPreviousButtonPressed() {
    var tempFocusedDate = focusedDate;
    if (calendarFormat == CalendarFormat.month) {
      if (selectedDate.month == 1) {
        tempFocusedDate = DateTime(focusedDate.year - 1, focusedDate.month);
      } else {
        tempFocusedDate = DateTime(focusedDate.year, focusedDate.month - 1);
      }
    } else {
      tempFocusedDate = focusedDate.subtract(const Duration(days: 7));
    }
    onFocusedDateChanged?.call(tempFocusedDate);
  }

  DateTime _startDateOf(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday));
    return startOfWeek;
  }

  DateTime _endDateOf(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday));
    return startOfWeek.add(const Duration(days: 6));
  }

  Widget _monthHeaderView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 50,
          ),
          Row(
            children: [
              IconButton(
                  onPressed:
                      _canPressPastButton() ? _onPreviousButtonPressed : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white
                        .withValues(alpha: _canPressPastButton() ? 1.0 : 0.3),
                  )),
              Text(
                DateFormat('MMM yyyy').format(focusedDate),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                  onPressed:
                      _canPressNextButton() ? _onNextButtonPressed : null,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white
                        .withValues(alpha: _canPressNextButton() ? 1.0 : 0.3),
                  )),
            ],
          ),
          showsCalendarFormatChanger
              ? InkWell(
                  onTap: () {
                    onCalendarFormatChanged?.call(CalendarFormat.week);
                  },
                  child: SvgPicture.asset(
                    Images.monthCalendarIcon,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ))
              : const SizedBox(
                  width: 50,
                ),
        ],
      ),
    );
  }

  bool _canPressNextButton() {
    if (maxFutureDate == null) {
      return true;
    }
    if (calendarFormat == CalendarFormat.month) {
      final currentCalendarViewMonthEndDate = focusedDate.endOfOfMonth;
      final maxFutureDateMonthStartDate = maxFutureDate!.endOfOfMonth;
      final comparision = maxFutureDateMonthStartDate
          .compareTo(currentCalendarViewMonthEndDate);
      return comparision == 1;
    } else {
      final currentCalendarViewWeekEndDate = focusedDate.endOfWeek;
      final maxFutureDateWeekEndDate = maxFutureDate!.endOfWeek;
      final comparision =
          maxFutureDateWeekEndDate.compareTo(currentCalendarViewWeekEndDate);
      return comparision == 1;
    }
  }

  bool _canPressPastButton() {
    if (maxPastDate == null) {
      return true;
    }
    if (calendarFormat == CalendarFormat.month) {
      final currentCalendarViewMonthStartDate = focusedDate.startOfMonth;
      final maxPastDateMonthStartDate = maxPastDate!.startOfMonth;
      final comparision = maxPastDateMonthStartDate
          .compareTo(currentCalendarViewMonthStartDate);
      return comparision == -1;
    } else {
      final currentCalendarViewMonthStartDate = focusedDate.startOfWeek;
      final maxPastDateMonthStartDate = maxPastDate!.startOfWeek;
      final comparision = maxPastDateMonthStartDate
          .compareTo(currentCalendarViewMonthStartDate);
      return comparision == -1;
    }
  }
}
