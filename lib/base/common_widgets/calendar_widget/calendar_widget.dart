import 'package:echowater/base/common_widgets/calendar_widget/calendar_header_view.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/services/debounce_handler.dart';
import '../../app_specific_widgets/app_boxed_container.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget(
      {required this.onDateSelected,
      required this.onWeekMonthChanged,
      required this.selectedDate,
      required this.focusedDate,
      required this.events,
      this.maxFutureDate,
      this.maxPastDate,
      super.key});
  final Function(CalendarFormat format, DateTime selectedDate) onDateSelected;
  final Function(CalendarFormat format, DateTime focusedDate)
      onWeekMonthChanged;
  final DateTime selectedDate;
  final DateTime focusedDate;
  final List<DateTime> events;
  final DateTime? maxPastDate;
  final DateTime? maxFutureDate;

  @override
  State<CalendarWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  var _calendarFormat = Constants.defaultCalendarView;
  var _focusedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var _events = <DateTime>[];

  final buttonDebounceHandler =
      DebounceHandler(debounceDuration: const Duration(seconds: 2));

  @override
  void initState() {
    setData(widget.events, widget.selectedDate, widget.focusedDate);
    super.initState();
  }

  void setData(
      List<DateTime> events, DateTime selectedDate, DateTime focusedDate) {
    _events = events;
    _focusedDate = focusedDate;
    _selectedDate = selectedDate;
    setState(() {});
  }

  bool _isSameMonth(DateTime day1, DateTime day2) {
    return day1.month == day2.month && day1.year == day2.year;
  }

  @override
  void dispose() {
    buttonDebounceHandler.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    widget.onWeekMonthChanged.call(_calendarFormat, _focusedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      child: Column(
        children: <Widget>[
          _headerView(),
          TableCalendar(
            availableGestures: AvailableGestures.none,
            calendarFormat: _calendarFormat,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) {
              if (day == _selectedDate) {
                return true;
              }
              return day == _selectedDate;
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDate = focusedDay;
              setState(() {});
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                return _getMarkerView(events as List<DateTime>, day);
              },
              outsideBuilder: (context, day, focusedDay) {
                return _getOutsideDayView(day);
              },
              defaultBuilder: (context, day, focusedDay) {
                return _getDefaultDayView(day);
              },
              selectedBuilder: (context, day, focusedDay) {
                return _getSelectedDayView(day);
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (_isSameMonth(selectedDay, focusedDay)) {
                _focusedDate = selectedDay;
                _selectedDate = selectedDay;
                widget.onDateSelected.call(_calendarFormat, _selectedDate);
                setState(() {});
              }
            },
            headerVisible: false,
            eventLoader: (day) {
              return _events;
            },
          ),
        ],
      ),
    );
  }

  Widget _getMarkerView(List<DateTime> events, DateTime day) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }
    for (final event in events) {
      if (event.year == day.year &&
          event.month == day.month &&
          event.day == day.day) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: const Color(0xffC4A6B5),
              borderRadius: BorderRadius.circular(5)),
          height: 5,
          width: 5,
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _getOutsideDayView(DateTime day) {
    return Center(
      child: Text(
        day.day.toString(),
        style: TextStyle(
            color: day.month == _focusedDate.month
                ? Colors.white
                : const Color(0xff9F9F9F)),
      ),
    );
  }

  Widget _getSelectedDayView(DateTime day) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xff03A2B1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
              color: day.month == _focusedDate.month
                  ? Colors.white
                  : const Color(0xff9F9F9F)),
        ),
      ),
    );
  }

  Widget _getDefaultDayView(DateTime day) {
    return Center(
      child: Text(
        day.day.toString(),
        style: TextStyle(
            color: day.month == _focusedDate.month
                ? Colors.white
                : const Color(0xff9F9F9F)),
      ),
    );
  }

  Widget _headerView() {
    return CalendarHeaderView(
        calendarFormat: _calendarFormat,
        focusedDate: _focusedDate,
        selectedDate: _selectedDate,
        maxFutureDate: widget.maxFutureDate,
        showsCalendarFormatChanger: true,
        maxPastDate: widget.maxPastDate,
        onCalendarFormatChanged: (format) {
          _calendarFormat = format;
          setState(() {});
        },
        onFocusedDateChanged: (date) {
          _focusedDate = date;
          setState(() {});
          buttonDebounceHandler.onButtonPressed(_onButtonPressed);
        });
  }
}
