import 'package:calendar_view/calendar_view.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/customize_protocol_entity/customize_protocol_entity.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/widget/edit_custom_event.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/widget/new_custom_event.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../base/app_specific_widgets/switch_view.dart';
import '../../../../base/common_widgets/alert/alert.dart';
import '../../../../base/common_widgets/bar/accessory_bar.dart';
import '../../../../base/common_widgets/buttons/app_button.dart';
import '../../../../base/common_widgets/day_selection_view/day_selection_view.dart';
import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../../base/utils/colors.dart';
import '../../../../base/utils/date_utils.dart';
import '../../../../base/utils/utilities.dart';
import '../../../../core/domain/entities/event_entity.dart';
import '../../../../core/injector/injector.dart';
import '../widget/repeat_custom_dropdown_button.dart';
import '../widget/single_item_event.dart';
import 'bloc/edit_custom_protocol_bloc.dart';

class EditCustomProtocolDialog extends StatefulWidget {
  const EditCustomProtocolDialog(
      {required this.model,
      required this.onSaved,
      this.isFromBlankTemplate = false,
      super.key});

  final ProtocolDetailsEntity model;
  final bool isFromBlankTemplate;

  final VoidCallback onSaved;

  @override
  State<EditCustomProtocolDialog> createState() =>
      _EditCustomProtocolDialogState();
}

class _EditCustomProtocolDialogState extends State<EditCustomProtocolDialog> {
  late final EditCustomProtocolBloc _bloc;

  DayModel? selectedDay;
  List<CalendarEventData<RoutineItemEntity>> events = [];
  final now = DateTime.now();
  late CustomizeProtocolEntity _tempCustomizeProtocolModel;
  final protocolTitleController = TextEditingController();
  ValueNotifier<String> eventSelectionNotifier = ValueNotifier(repeatList[1]);

  @override
  void initState() {
    _bloc = Injector.instance<EditCustomProtocolBloc>();
    _bloc.add(ResetCustomProtocolEvent(model: widget.model));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AccessoryBar(
              title:
                  widget.isFromBlankTemplate ? 'Custom Protocol' : 'Customize',
              doneText: 'Save',
              onDonePressed: () {
                if (protocolTitleController.text.isEmpty) {
                  Utilities.showSnackBar(context, 'Please enter protocol title',
                      SnackbarStyle.error);
                  return;
                }
                final tempModel = CustomizeProtocolEntity(
                    id: widget.model.id,
                    title: protocolTitleController.text,
                    category: 'custom',
                    image: _tempCustomizeProtocolModel.image,
                    isActive: _tempCustomizeProtocolModel.isActive,
                    isTemplate: _tempCustomizeProtocolModel.isTemplate,
                    routines: _tempCustomizeProtocolModel.routines,
                    protocol: _tempCustomizeProtocolModel.protocol);
                _bloc.add(SaveCustomProtocolEvent(
                    id: widget.model.id.toString(),
                    model: tempModel,
                    isFromBlankTemplate: widget.isFromBlankTemplate));
              },
              onCancelPressed: () {
                Navigator.pop(context);
              },
            ),
            const Divider(
              color: AppColors.tertiaryBackgroundColorDark,
            ),
            BlocConsumer<EditCustomProtocolBloc, EditCustomProtocolState>(
              bloc: _bloc,
              listener: (context, state) {
                _onStateChanged(state, context);
              },
              builder: (context, state) {
                if (state is EditCustomProtocolLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        AppTextField.textField(
                            context: context,
                            hint: 'Protocol Title',
                            validator: () => null,
                            textCapitalization: TextCapitalization.none,
                            backgroundColor: AppColors.transparent,
                            hasMandatoryBorder: true,
                            controller: protocolTitleController,
                            textColor: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                            borderColor: AppColors.tertiaryElementColor),
                        const SizedBox(
                          height: 8,
                        ),
                        _headerText(),
                        const SizedBox(
                          height: 8,
                        ),
                        DaySelectionView(
                          routines: _tempCustomizeProtocolModel.routines,
                          onItemClick: (model) {
                            events.clear();
                            selectedDay = model;

                            for (final item in model.routineItem) {
                              events.add(CalendarEventData(
                                  title: item.title,
                                  date: now,
                                  event: item,
                                  startTime: DateUtil.parseProtocolTime(
                                      item.startTime, now),
                                  endTime: DateUtil.parseProtocolTime(
                                      item.endTime, now)));
                            }

                            setState(() {});
                          },
                        ),
                        if (selectedDay != null)
                          SwitchView(
                            title: selectedDay!.isActiveDay
                                ? '${selectedDay!.dayName.capitalizeFirst()} is an Active Day'
                                : '${selectedDay!.dayName.capitalizeFirst()} is a Rest Day',
                            isOn: selectedDay!.isActiveDay,
                            onChange: (value) {
                              selectedDay!.isActiveDay = value;

                              for (final element
                                  in _tempCustomizeProtocolModel.routines) {
                                if (element.day == selectedDay!.dayName) {
                                  element.activeDay = value;
                                  break;
                                }
                              }
                              setState(() {});
                            },
                          ),
                        Stack(
                          children: [
                            _calendarView(),
                            Positioned(
                              bottom: 0,
                              right: 24,
                              left: 24,
                              child: SafeArea(
                                child: AppButton(
                                    title: 'Apply schedule to other days',
                                    height: 45,
                                    radius: 22.5,
                                    hasGradientBackground: true,
                                    onClick: () {
                                      _showDropdownDialog();
                                    }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (state is EditCustomProtocolLoading) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(child: Loader()));
                } else if (state is EditCustomProtocolFetchApiErrorState) {
                  return Text(state.errorMessage);
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  // Default selection

  Future<void> _showDropdownDialog() async {
    await showDialog<String>(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
            valueListenable: eventSelectionNotifier,
            builder: (context, tempSelection, child) {
              return AlertDialog(
                backgroundColor: AppColors.mainBackgroundColorDark,
                title: const Text('Repeat'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: repeatList.sublist(1, 4).map((option) {
                    return RadioListTile<String>(
                      title: Text(option,
                          style: Theme.of(context).textTheme.bodyMedium),
                      value: option,
                      groupValue: tempSelection,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        if (value != null) {
                          eventSelectionNotifier.value = value;
                        }
                      },
                      dense: true,
                    );
                  }).toList(),
                ),
                actions: [
                  OverflowBar(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AppButton(
                            title: 'Cancel',
                            height: 35,
                            width: 100,
                            radius: 22.5,
                            backgroundColor: Colors.transparent,
                            border: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryElementColor),
                            onClick: () {
                              Navigator.pop(context);
                            }),
                      ),
                      AppButton(
                          title: 'Apply',
                          height: 35,
                          radius: 22.5,
                          width: 100,
                          hasGradientBackground: true,
                          onClick: () {
                            Navigator.pop(context);
                            _showApplyScheduleAlert(tempSelection);
                          }),
                    ],
                  ),
                ],
              );
            });
      },
    );
  }

  void _showApplyScheduleAlert(String eventSelectionType) {
    final alert = Alert();
    alert.showAlert(
        context: context,
        isWarningAlert: true,
        message:
            'Are you sure you want to apply this schedule to ${eventSelectionNotifier.value}? This will overwrite the information on other days.',
        actionWidget: alert.getDefaultTwoButtons(
            firstButtonTitle: 'Not Now',
            lastButtonTitle: 'Apply',
            onFirstButtonClick: () {
              Navigator.pop(context);
            },
            onLastButtonClick: () {
              Navigator.pop(context);
              _overwriteEventDays(eventSelectionType);
            },
            context: context,
            isAlternate: true));
  }

  Widget _calendarView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: DayView(
        controller: EventController()..addAll(events),
        showVerticalLine: false,
        pageViewPhysics: const NeverScrollableScrollPhysics(),
        backgroundColor: AppColors.black,
        eventTileBuilder: (date, events, boundry, start, end) {
          return SingleItemEvent(events: events);
        },
        fullDayEventBuilder: (events, date) {
          return const SizedBox.shrink();
        },
        showLiveTimeLineInAllDays: true,
        minDay: DateTime(2024),
        maxDay: DateTime(2080),
        initialDay: DateTime.now(),
        heightPerMinute: 1,
        eventArranger: const SideEventArranger(),
        onEventTap: (events, date) => {},
        onEventDoubleTap: (events, date) => print(events),
        onEventLongTap: (event, date) => {
          Utilities.showBottomSheet(
              widget: EditCustomEvent(
                eventData: event.first,
                onSave: (model) {
                  events.remove(event.first);
                  addNewEvent(model,
                      oldEvent: event.first.event! as RoutineItemEntity);
                  // editEvent(model, event.first.event! as RoutineItem);
                },
              ),
              context: context)
        },
        onDateLongPress: (date) => {
          Utilities.showBottomSheet(
              widget: NewCustomEvent(
                dateTime: date,
                onSave: (model) {
                  addNewEvent(model);
                },
              ),
              context: context)
        },
        hourIndicatorSettings: const HourIndicatorSettings(
            color: AppColors.tertiaryBackgroundColorDark),
        dayTitleBuilder: DayHeader.hidden,
        keepScrollOffset: true,
      ),
    );
  }

  void addNewEvent(EventEntity model, {RoutineItemEntity? oldEvent}) {
    final startTime = DateFormat('HH:mm:ss').format(model.startTime);
    final endTime = DateFormat('HH:mm:ss').format(model.endTime);
    final normalizedRepeat = model.repeat.trim().toLowerCase();
    final isOvernight = model.startTime.isAfter(model.endTime);

    final item1 = RoutineItemEntity(
        id: model.id,
        title: model.title,
        startTime: startTime,
        endTime: isOvernight ? '23:59:59' : endTime);
    final item2 = isOvernight
        ? RoutineItemEntity(
            id: model.id,
            title: model.title,
            startTime: '00:00:00',
            endTime: endTime)
        : null;

    void updateRoutine(
        ProtocolRoutineEntity routine, RoutineItemEntity newItem) {
      routine.items.removeWhere((item) =>
          item.startTime == newItem.startTime &&
          item.endTime == newItem.endTime);
      routine.items.add(newItem);
    }

    for (final routine in _tempCustomizeProtocolModel.routines) {
      if (oldEvent != null &&
          selectedDay!.dayName.trim().toLowerCase() ==
              routine.day.trim().toLowerCase()) {
        routine.items.remove(oldEvent);
        updateRoutine(routine, item1);
      }

      if (normalizedRepeat == repeatList[0].trim().toLowerCase() &&
              routine.day == selectedDay!.dayName ||
          normalizedRepeat == repeatList[1].trim().toLowerCase() ||
          (normalizedRepeat == repeatList[2].trim().toLowerCase() &&
              routine.activeDay) ||
          (normalizedRepeat == repeatList.last.trim().toLowerCase() &&
              !routine.activeDay)) {
        updateRoutine(routine, item1);
        if (item2 != null) {
          updateRoutine(routine, item2);
        }
      }
    }

    events.add(CalendarEventData(
      title: model.title,
      date: now,
      event: item1,
      startTime: DateUtil.parseProtocolTime(item1.startTime, now),
      endTime: DateUtil.parseProtocolTime(item1.endTime, now),
    ));
    if (item2 != null) {
      events.add(CalendarEventData(
        title: model.title,
        date: now,
        event: item2,
        startTime: DateUtil.parseProtocolTime(item2.startTime, now),
        endTime: DateUtil.parseProtocolTime(item2.endTime, now),
      ));
    }
    setState(() {});
  }

  void _overwriteEventDays(String eventSelectionType) {
    final tempItem = <RoutineItemEntity>[];
    final tempItem2 = <RoutineItemEntity>[];
    if (eventSelectionType == repeatList[1]) {
      for (final routine in _tempCustomizeProtocolModel.routines) {
        if (routine.day.trim().toLowerCase() ==
            selectedDay!.dayName.trim().toLowerCase()) {
          tempItem.addAll(routine.items);
        }
      }
      for (final routine in _tempCustomizeProtocolModel.routines) {
        routine.items.clear();
        routine.items.addAll(tempItem);
      }
    } else if (eventSelectionType == repeatList[2]) {
      for (final routine in _tempCustomizeProtocolModel.routines) {
        if (routine.day.trim().toLowerCase() ==
            selectedDay!.dayName.trim().toLowerCase()) {
          tempItem2.addAll(routine.items);
        }
      }
      for (final routine in _tempCustomizeProtocolModel.routines) {
        if (routine.activeDay) {
          if (tempItem2.isNotEmpty) {
            tempItem.addAll(tempItem2);
            tempItem2.clear();
          }

          routine.items.clear();
          routine.items.addAll(tempItem);
        }
      }
    } else if (eventSelectionType == repeatList[3]) {
      for (final routine in _tempCustomizeProtocolModel.routines) {
        if (routine.day.trim().toLowerCase() ==
            selectedDay!.dayName.trim().toLowerCase()) {
          tempItem2.addAll(routine.items);
        }
      }
      for (final routine in _tempCustomizeProtocolModel.routines) {
        if (!routine.activeDay) {
          if (tempItem2.isNotEmpty) {
            tempItem.addAll(tempItem2);
            tempItem2.clear();
          }
          routine.items.clear();
          routine.items.addAll(tempItem);
        }
      }
    }

    setState(() {});
  }

  void _showResetToDefaultAlert() {
    final alert = Alert();
    alert.showAlert(
        context: context,
        isWarningAlert: true,
        message:
            'Do you really want to reset custom protocol data to the default settings ?',
        actionWidget: alert.getDefaultTwoButtons(
            firstButtonTitle: 'Cancel',
            lastButtonTitle: 'Reset',
            onFirstButtonClick: () {
              Navigator.pop(context);
            },
            onLastButtonClick: () {
              Navigator.pop(context);

              _bloc.add(ResetCustomProtocolEvent(model: widget.model));
            },
            context: context,
            isAlternate: true));
  }

  Widget _headerText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select day to Customize',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        InkWell(
            onTap: _showResetToDefaultAlert,
            child: Text('Reset to Default',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.primaryLight)))
      ],
    );
  }

  void _onStateChanged(EditCustomProtocolState state, BuildContext context) {
    if (state is EditCustomProtocolFetchApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is EditCustomProtocolLoaded) {
      _tempCustomizeProtocolModel = state.model;
      // _tempCustomizeProtocolModel = state.model.title
      protocolTitleController.text = _tempCustomizeProtocolModel.title;
    } else if (state is SaveCustomProtocolLoaded) {
      widget.onSaved.call();
    }
  }
}
