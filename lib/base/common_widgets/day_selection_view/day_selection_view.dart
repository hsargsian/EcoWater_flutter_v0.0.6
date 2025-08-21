import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelectionView extends StatefulWidget {
  const DaySelectionView({required this.routines, required this.onItemClick, this.headerWidget, super.key});

  final Widget? headerWidget;
  final List<ProtocolRoutineEntity> routines;
  final Function(DayModel model) onItemClick;

  @override
  State<DaySelectionView> createState() => DaySelectionViewState();
}

class DaySelectionViewState extends State<DaySelectionView> {
  List<DayModel> routines = [];

  @override
  void initState() {
    super.initState();
    _generateDayModels();
  }

  @override
  void didUpdateWidget(covariant DaySelectionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routines != widget.routines) {
      routines.clear();
      _generateDayModels();
    }
  }

  void _generateDayModels() {
    if (widget.routines.isNotEmpty) {
      final existingDays = {for (var item in widget.routines) item.day.toLowerCase()};

      for (final action in Day.values) {
        final dayName = action.name.toLowerCase();
        if (existingDays.contains(dayName)) {
          final items = widget.routines.firstWhere((item) => item.day.toLowerCase() == dayName);
          routines.add(DayModel(items.items, items.day, items.activeDay));
        } else {
          routines.add(DayModel([], action.name, false));
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weekName = DateFormat.EEEE().format(DateTime.now());
      for (final element in routines) {
        element.isItemClick = (element.dayName == weekName);
        if (element.isItemClick) {
          onItemClick(element);
        }
      }
    });
  }

  void onItemClick(DayModel item) {
    for (final element in routines) {
      element.isItemClick = element.isItemClick = (element.dayName == item.dayName);
    }

    widget.onItemClick(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.headerWidget != null) widget.headerWidget!,
        SizedBox(
            height: 50,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: routines.map((item) {
                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () {
                            onItemClick(item);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    item.isItemClick ? Border.all(color: AppColors.white) : Border.all(color: Colors.transparent),
                                color: item.isActiveDay
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text(
                              item.dayName.firstCharacter!.toUpperCase(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            )),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ))
      ],
    );
  }
}

class DayModel {
  DayModel(this.routineItem, this.dayName, this.isActiveDay, {this.isItemClick = false});

  final List<RoutineItemEntity> routineItem;
  final String dayName;
  bool isItemClick;
  bool isActiveDay;
}

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;
}
