import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import 'package:echowater/base/app_specific_widgets/graph_view/graph_view.dart';
import 'package:echowater/base/common_widgets/segmented_control_view/segmented_control_item.dart';
import 'package:echowater/base/common_widgets/segmented_control_view/segmented_control_view.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/domain/domain_models/personal_goal_graph_domain.dart';
import '../../../core/services/debounce_handler.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../common_widgets/calendar_widget/calendar_header_view.dart';
import '../../utils/colors.dart';

class GraphViewWrapperView extends StatefulWidget {
  const GraphViewWrapperView(
      {required this.onWeekMonthChanged,
      required this.goalData,
      required this.focusedDate,
      this.maxPastDate,
      this.maxFutureDate,
      super.key});

  final Function(
          CalendarFormat format, DateTime focusedDate, BottleOrPPMType goalType)
      onWeekMonthChanged;
  final List<PersonalGoalGraphDomain> goalData;
  final DateTime focusedDate;
  final DateTime? maxPastDate;
  final DateTime? maxFutureDate;

  @override
  State<GraphViewWrapperView> createState() => GraphViewWrapperViewState();
}

class GraphViewWrapperViewState extends State<GraphViewWrapperView> {
  BottleOrPPMType _selectedType = BottleOrPPMType.bottle;
  CalendarFormat _selectedCalendarType = CalendarFormat.week;
  DateTime _focusedDate = DateTime.now();
  List<PersonalGoalGraphDomain> _goalData = [];
  Map<String, dynamic>? _selectedItem;

  final buttonDebounceHandler =
      DebounceHandler(debounceDuration: const Duration(seconds: 1));

  @override
  void initState() {
    setData(widget.goalData, widget.focusedDate);
    super.initState();
  }

  @override
  void dispose() {
    buttonDebounceHandler.dispose();
    super.dispose();
  }

  void _callBack() {
    widget.onWeekMonthChanged
        .call(_selectedCalendarType, _focusedDate, _selectedType);
  }

  void _onCallback() {
    buttonDebounceHandler.onButtonPressed(_callBack);
  }

  void setData(List<PersonalGoalGraphDomain> goalData, DateTime focusedDate) {
    _goalData = goalData;
    _focusedDate = focusedDate;
    _selectedItem = null;
    setState(() {});
  }

  Widget _placeholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppBoxedContainer(
        borderSides: const [AppBorderSide.bottom],
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 25, left: 20, right: 20),
          child: Shimmer.fromColors(
            baseColor: AppColors.color717171Base,
            highlightColor: AppColors.color717171Base.withValues(alpha: 0.8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    color: Theme.of(context).colorScheme.secondary,
                    height: 30,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _goalData.isEmpty
        ? _placeholder(context)
        : Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: AppBoxedContainer(
                borderSides: const [AppBorderSide.bottom],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WalkThroughWrapper(
                      hasWalkThough:
                          WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.homeBottleAndPpm,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            SegmentedControlView(
                              items: [
                                SegmentedControlItem(
                                    onTapped: () {
                                      _selectedType = BottleOrPPMType.bottle;
                                      setState(() {});
                                      _onCallback();
                                    },
                                    isSelected:
                                        _selectedType == BottleOrPPMType.bottle,
                                    index: 0,
                                    unselectedBackgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor
                                        .withValues(alpha: 0),
                                    selectedBackgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    title: BottleOrPPMType
                                        .bottle.segmentedControlTitle),
                                SegmentedControlItem(
                                    onTapped: () {
                                      _selectedType = BottleOrPPMType.ppms;
                                      setState(() {});
                                      _onCallback();
                                    },
                                    unselectedBackgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor
                                        .withValues(alpha: 0),
                                    selectedBackgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    isSelected:
                                        _selectedType == BottleOrPPMType.ppms,
                                    index: 0,
                                    title: BottleOrPPMType
                                        .ppms.segmentedControlTitle),
                                SegmentedControlItem(
                                    onTapped: () {
                                      _selectedType = BottleOrPPMType.water;
                                      setState(() {});
                                      _onCallback();
                                    },
                                    isSelected:
                                        _selectedType == BottleOrPPMType.water,
                                    index: 0,
                                    unselectedBackgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor
                                        .withValues(alpha: 0),
                                    selectedBackgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    title: BottleOrPPMType
                                        .water.segmentedControlTitle),
                              ],
                              size: 38,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SegmentedControlView(
                              items: [
                                SegmentedControlItem(
                                    onTapped: () {
                                      _selectedCalendarType =
                                          CalendarFormat.week;
                                      setState(() {});
                                      _onCallback();
                                    },
                                    unselectedBackgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor
                                        .withValues(alpha: 0.05),
                                    selectedBackgroundColor: Colors.transparent,
                                    isSelected: _selectedCalendarType ==
                                        CalendarFormat.week,
                                    index: 0,
                                    showsBottomDivider: true,
                                    title: 'Week'.localized),
                                SegmentedControlItem(
                                    onTapped: () {
                                      _selectedCalendarType =
                                          CalendarFormat.month;
                                      setState(() {});
                                      _onCallback();
                                    },
                                    isSelected: _selectedCalendarType ==
                                        CalendarFormat.month,
                                    index: 0,
                                    unselectedBackgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryElementColor
                                        .withValues(alpha: 0.05),
                                    showsBottomDivider: true,
                                    selectedBackgroundColor: Colors.transparent,
                                    title: 'Month'.localized),
                              ],
                              size: 38,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          _headerView(),
                        ],
                      ),
                    ),
                    WalkThroughWrapper(
                      hasWalkThough:
                          WalkThroughManager().currentWalkthroughItem ==
                              WalkThroughItem.homeConsumptionProgress,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: GraphView(
                          headerTitle: _selectedType.graphHeaderTitle,
                          subWidget: _subWidgetView(),
                          selectedItem: _selectedItem,
                          calendarType: _selectedCalendarType,
                          focusedDate: _focusedDate,
                          onItemClick: (p0) {
                            _setSelectedItem(p0);
                          },
                          data: _goalData.map((item) {
                            return <String, dynamic>{
                              'goal': item.goal,
                              'actual': item.actual,
                              'date': item.date,
                            };
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )),
          );
  }

  void _setSelectedItem(Map<String, dynamic>? item) {
    if (_selectedItem == null || item == null) {
      _selectedItem = item;
      setState(() {});
      return;
    }
    _selectedItem = item['date'] == _selectedItem!['date'] ? null : item;
    setState(() {});
  }

  Widget? _subWidgetView() {
    return (_selectedItem == null)
        ? null
        : IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.color59585E,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xff00A7B5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 15,
                        height: 15,
                      ),
                      Text(
                          '${"Actual".localized} - ${_selectedItem!['actual']}')
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC4A6B5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 15,
                        height: 15,
                      ),
                      Text('${"Goal".localized} - ${_selectedItem!['goal']}')
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                        '• ${DateUtil.getDateFormatted(_selectedItem!['date'], 'yyyy-MM-dd', 'MMM dd, yyyy')}'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        _setSelectedItem(null);
                      },
                      child: Icon(
                        size: 20,
                        Icons.close,
                        color:
                            Theme.of(context).colorScheme.secondaryElementColor,
                      ))
                ],
              ),
            ),
          );
  }

  Widget _headerView() {
    return CalendarHeaderView(
        calendarFormat: _selectedCalendarType,
        focusedDate: _focusedDate,
        selectedDate: _focusedDate,
        maxFutureDate: widget.maxFutureDate,
        showsCalendarFormatChanger: false,
        maxPastDate: widget.maxPastDate,
        onCalendarFormatChanged: (format) {},
        onFocusedDateChanged: (date) {
          _focusedDate = date;
          setState(() {});
          _onCallback();
        });
  }
}
