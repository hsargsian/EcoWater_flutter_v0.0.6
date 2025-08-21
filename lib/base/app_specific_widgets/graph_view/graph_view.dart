import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/colors.dart';

class GraphView extends StatelessWidget {
  GraphView(
      {required this.headerTitle,
      required this.calendarType,
      required this.focusedDate,
      required this.data,
      required this.onItemClick,
      required this.selectedItem,
      this.subWidget,
      super.key});

  final String headerTitle;
  final Widget? subWidget;
  final CalendarFormat calendarType;
  final DateTime focusedDate;
  final List<Map<String, dynamic>> data;
  final Map<String, dynamic>? selectedItem;
  final Function(Map<String, dynamic>) onItemClick;

  double height = 250;

  List<Map<String, dynamic>> _values = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _midDate = DateTime.now();

  List<int> _generateIntervals() {
    var maxGoal = _values.map((item) => item['goal']!).reduce((a, b) => a > b ? a : b);

    final maxActualGoalAcheived = _values.map((item) => item['actual']!).reduce((a, b) => a > b ? a : b);
    maxGoal = maxGoal > maxActualGoalAcheived ? maxGoal : maxActualGoalAcheived;
    final steps = _calculateSteps(maxGoal);
    const baseVal = 0;

    final intervals = <int>[];
    for (var i = baseVal; i <= maxGoal; i += steps) {
      intervals.add(i);
    }

    if (intervals.last < maxGoal) {
      intervals.add(intervals.last + steps);
    }

    return intervals.reversed.toList();
  }

  List<Map<String, dynamic>> _fillRemainingValues(List<Map<String, dynamic>> values, DateTime startDate, DateTime endDate) {
    final totalDays = endDate.difference(startDate).inDays + 1; // +1 to include end date
    final filledValues = List<Map<String, dynamic>>.from(values);

    // Fill remaining days with {'goal': 0, 'actual': 0}
    for (var i = values.length; i < totalDays; i++) {
      filledValues.add({'goal': 0, 'actual': 0});
    }

    return filledValues;
  }

  int _calculateSteps(num max) {
    const intervalsMap = [
      {'threshold': 5, 'intervals': 1},
      {'threshold': 10, 'intervals': 2},
      {'threshold': 20, 'intervals': 4},
      {'threshold': 30, 'intervals': 6},
      {'threshold': 40, 'intervals': 8},
      {'threshold': 50, 'intervals': 10},
      {'threshold': 100, 'intervals': 20},
      {'threshold': 500, 'intervals': 100},
      {'threshold': 1000, 'intervals': 200},
      {'threshold': 2000, 'intervals': 500},
      {'threshold': 5000, 'intervals': 1000},
      {'threshold': 10000, 'intervals': 1500},
      {'threshold': 100000, 'intervals': 5000},
    ];

    for (final entry in intervalsMap) {
      if (max <= entry['threshold']!) {
        return entry['intervals']!;
      }
    }

    return 500;
  }

  void _configureData() {
    if (calendarType == CalendarFormat.month) {
      _startDate = focusedDate.startOfMonth;
      _endDate = focusedDate.endOfOfMonth;
      _midDate = _getMiddleDate(_startDate, _endDate);
      _values = _fillRemainingValues(data, _startDate, _endDate);
    } else {
      _startDate = focusedDate.startOfWeek;
      _endDate = focusedDate.endOfWeek;
      _midDate = _getMiddleDate(_startDate, _endDate);
      _values = _fillRemainingValues(data, _startDate, _endDate);
    }
  }

  Widget _noDataView() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text('no_data_available'.localized),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _configureData();
    final intervals = _generateIntervals();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          headerTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 10,
        ),
        if (subWidget != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(
              children: [
                subWidget!,
              ],
            ),
          ),
        AnimatedSize(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: intervals.length <= 1 ? _noDataView() : _graphView(context, intervals)),
        _xLegendView(context),
        _mainLegendView(context),
      ],
    );
  }

  Widget _graphView(BuildContext context, List<int> intervals) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: height * 0.90,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: intervals
                          .map((item) => Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.2),
                              ))
                          .toList(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(_values.length, (index) => index).map((item) {
                        final valueItem = _values[item];
                        return Expanded(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 50,
                                color: Colors.transparent,
                              ),
                              _goalBarView(context, valueItem, constraints, intervals),
                              _achievedGoalBarView(context, valueItem, constraints, intervals),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
              },
            ),
          )),
          SizedBox(
            width: 50,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: intervals
                  .map((item) => Text(
                        item.toString(),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _goalBarView(BuildContext context, Map<String, dynamic> valueItem, BoxConstraints constraints, List<int> intervals) {
    return (valueItem['actual'] == 0 && valueItem['goal'] == 0)
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () {
              onItemClick.call(valueItem);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: _getGoalValueColor(context, valueItem),
              ),
              margin: EdgeInsets.symmetric(horizontal: calendarType == CalendarFormat.month ? 3 : 5),
              height: constraints.maxHeight * (valueItem['goal']! / intervals.first),
            ),
          );
  }

  Widget _achievedGoalBarView(
      BuildContext context, Map<String, dynamic> valueItem, BoxConstraints constraints, List<int> intervals) {
    return (valueItem['actual'] == 0 && valueItem['goal'] == 0)
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () {
              onItemClick.call(valueItem);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: _getActualValueColor(context, valueItem),
              ),
              margin: EdgeInsets.symmetric(horizontal: calendarType == CalendarFormat.month ? 3 : 5),
              height: constraints.maxHeight * (valueItem['actual']! / intervals.first),
            ),
          );
  }

  Color _getGoalValueColor(BuildContext context, Map<String, dynamic> item) {
    if (selectedItem == null) {
      return const Color(0xFFC4A6B5);
    }
    return item['date'] == selectedItem!['date'] ? const Color(0xFFC4A6B5) : AppColors.color717171.withValues(alpha: 0.6);
  }

  Color _getActualValueColor(BuildContext context, Map<String, dynamic> item) {
    if (selectedItem == null) {
      return const Color(0xff00A7B5);
    }
    return item['date'] == selectedItem!['date'] ? const Color(0xff00A7B5) : AppColors.color717171Base.withValues(alpha: 0.6);
  }

  Widget _mainLegendView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getItem('Actual'.localized, const Color(0xff00A7B5), context),
          _getItem('Goal'.localized, const Color(0xFFC4A6B5), context)
        ],
      ),
    );
  }

  Widget _xLegendView(BuildContext context) {
    switch (calendarType) {
      case CalendarFormat.twoWeeks:
        return Container();
      case CalendarFormat.week:
        return Row(
          children: [
            Expanded(
                child: Row(
              children: _weekdays.map((item) {
                return Expanded(
                    child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                ));
              }).toList(),
            )),
            const SizedBox(
              width: 50,
            )
          ],
        );
      case CalendarFormat.month:
        return Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    DateFormat('MMM d').format(_startDate),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                  )),
                  Expanded(
                      child: Text(
                    DateFormat('MMM d').format(_midDate),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                  )),
                  Expanded(
                      child: Text(
                    DateFormat('MMM d').format(_endDate),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                  ))
                ],
              ),
            ),
            const SizedBox(
              width: 50,
            )
          ],
        );
    }
  }

  final List<String> _weekdays = List.generate(7, (index) {
    final date = DateTime.utc(2024, 7, 7 + index); // July 9th, 2024 is a Monday
    return DateFormat.E().format(date); // E() gives the abbreviated weekday name
  });

  Widget _getItem(String title, Color indicatorColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            width: 40,
            height: 15,
            decoration: BoxDecoration(color: indicatorColor, borderRadius: BorderRadius.circular(10)),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }

  DateTime _getMiddleDate(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);
    final halfDifference = Duration(days: (difference.inDays / 2).floor());

    return startDate.add(halfDifference);
  }
}
