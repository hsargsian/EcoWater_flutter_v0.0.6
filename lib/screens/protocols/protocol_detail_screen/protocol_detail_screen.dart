import 'package:calendar_view/calendar_view.dart';
import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/day_selection_view/day_selection_view.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/protocol_type_domain.dart';
import 'package:echowater/core/domain/domain_models/protocols_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/edit_custom_protocol/edit_custom_protocol_dialog.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/widget/more_custom_protocol.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/widget/update_protocol_goal_dialog.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/switch_view.dart';
import '../../../base/common_widgets/bar/accessory_bar.dart';
import '../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../base/common_widgets/protocol_active_button.dart';
import '../../../base/common_widgets/segmented_control_view/segmented_control_item.dart';
import '../../../base/common_widgets/segmented_control_view/segmented_control_view.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/date_utils.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/entities/CustomizeProtocolActiveRequestEntity/customize_protocol_active_request_entity.dart';
import '../../../core/injector/injector.dart';
import '../sub_views/protocols_listing_view/bloc/protocols_listing_bloc.dart';
import 'bloc/protocol_details_screen_bloc.dart';
import 'widget/single_item_event.dart';

class ProtocolDetailScreen extends StatefulWidget {
  const ProtocolDetailScreen(
      {required this.protocol, required this.bloc, required this.protocolType, required this.onRefreshedPage, super.key});

  final ProtocolDomain protocol;
  final String protocolType;
  final ProtocolsListingBloc bloc;
  final VoidCallback onRefreshedPage;

  @override
  State<ProtocolDetailScreen> createState() => _ProtocolDetailScreenState();
}

class _ProtocolDetailScreenState extends State<ProtocolDetailScreen> {
  late final ProtocolDetailsScreenBloc _bloc;

  bool _isShowingRotuine = true;
  final now = DateTime.now();

  List<CalendarEventData> events = [];
  DayModel? selectedDay;

  @override
  void initState() {
    _bloc = Injector.instance<ProtocolDetailsScreenBloc>();
    super.initState();
    _bloc.add(FetchProtocolDetailsEvent(id: widget.protocol.id, protocolType: widget.protocolType));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: [BoxShadow(offset: const Offset(0, -1), color: AppColors.color717171)]),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.9),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.secondary,
              child: BlocConsumer<ProtocolDetailsScreenBloc, ProtocolDetailsScreenState>(
                bloc: _bloc,
                listener: (context, state) {
                  _onStateChanged(state, context);
                },
                builder: (context, state) {
                  if (state is FetchingDetailsState) {
                    return const Center(child: Loader());
                  } else if (state is FetchedProtocolDetailsState) {
                    final model = state.model;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AccessoryBar(
                            title: 'Protocol'.localized,
                            doneText: 'Close',
                            onDonePressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _headerImageView(model),
                                    if (model.education.isNotEmpty) _segmentedControlView(),
                                    if (_isShowingRotuine)
                                      Column(
                                        children: [
                                          DaySelectionView(
                                            routines: model.routines,
                                            onItemClick: (model) {
                                              events.clear();
                                              selectedDay = model;
                                              for (final item in model.routineItem) {
                                                events.add(CalendarEventData(
                                                    title: item.title,
                                                    date: now,
                                                    event: item,
                                                    startTime: DateUtil.parseProtocolTime(item.startTime, now),
                                                    endTime: DateUtil.parseProtocolTime(item.endTime, now)));
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
                                              onChange: (value) {},
                                            ),
                                          _calendarView(),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    if (!_isShowingRotuine) _educationView(model)
                                  ],
                                ),
                              ),
                              _floatingButtonView(model)
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _educationView(ProtocolDetailsEntity model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why this protocol?',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontFamily: StringConstants.fieldGothicTestFont, fontSize: 24, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(model.education,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(stops: [
                          0.2,
                          0.4,
                          0.8
                        ], colors: [
                          Color.fromRGBO(3, 162, 177, 0.95),
                          Color.fromRGBO(99, 162, 178, 1),
                          Color.fromRGBO(195, 162, 179, 0.93),
                        ])),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.quotations[index].testimony,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(model.quotations[index].author, style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: model.quotations.length,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
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
        onEventDoubleTap: (events, date) {
          if (kDebugMode) {
            print(events);
          }
        },
        onEventLongTap: (events, date) => {},
        onDateLongPress: (date) => {},
        hourIndicatorSettings: const HourIndicatorSettings(color: AppColors.tertiaryBackgroundColorDark),
        dayTitleBuilder: DayHeader.hidden,
        keepScrollOffset: true,
      ),
    );
  }

  Widget _headerImageView(ProtocolDetailsEntity model) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            model.image.contains(Images.defaultProtocolImage)
                ? Image.asset(
                    Images.defaultProtocolImage,
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * 3 / 5,
                  )
                : AppImageView(
                    avatarUrl: model.image,
                    cornerRadius: 0,
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * 3 / 5,
                  ),
            Positioned.fill(
                child: Container(
              color: Colors.black54,
            )),
            Positioned(
                top: 10,
                right: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProtocolActiveButton(
                      isActive: model.isActive,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (widget.protocolType.toLowerCase() == ProtocolType.custom.name)
                      InkWell(
                          onTap: () {
                            Utilities.showBottomSheet(
                                widget: MoreCustomProtocol(
                                  deleteCustomProtocolTaped: () {
                                    Navigator.pop(context);
                                    _bloc.add(DeleteUserProtocolEvent(id: widget.protocol.id));
                                  },
                                  editCustomProtocolTaped: () {
                                    Navigator.pop(context);
                                    Utilities.showBottomSheet(
                                        isDismissable: false,
                                        widget: EditCustomProtocolDialog(
                                          model: model,
                                          onSaved: () {
                                            // widget.bloc.add(
                                            //     FetchProtocolsListingEvent(FetchStyle.normal, null, ProtocolType.custom.name));
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            widget.onRefreshedPage.call();
                                          },
                                        ),
                                        context: context);
                                  },
                                ),
                                context: context);
                          },
                          child: const Icon(
                            size: 30,
                            Icons.more_vert,
                            color: AppColors.white,
                          ))
                  ],
                )),
            Positioned(
                left: 10,
                bottom: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.category.capitalizeFirst(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      model.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.primaryElementColor, fontWeight: FontWeight.w700),
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }

  Widget _floatingButtonView(ProtocolDetailsEntity model) {
    return Positioned(
      bottom: 5,
      left: 20,
      right: 20,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: AppButton(
                    title: 'Customize',
                    height: 45,
                    radius: 22.5,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
                    onClick: () {
                      Utilities.showBottomSheet(
                          isDismissable: false,
                          widget: EditCustomProtocolDialog(
                            model: model,
                            onSaved: () {
                              // widget.bloc.add(FetchProtocolsListingEvent(FetchStyle.normal, null, ProtocolType.custom.name));
                              Navigator.pop(context);
                              Navigator.pop(context);
                              widget.onRefreshedPage.call();
                            },
                          ),
                          context: context);
                    })),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: AppButton(
                    title: model.isActive ? 'Deactivate' : 'Activate',
                    height: 45,
                    radius: 22.5,
                    hasGradientBackground: true,
                    onClick: () {
                      if (model.isActive) {
                        _bloc.add(UpdateProtocolGoalEvent(
                            model: CustomizeProtocolActiveRequestEntity(
                                protocolType: model.isTemplate ? ProtocolType.template.name : ProtocolType.custom.name,
                                protocolId: int.parse(widget.protocol.id),
                                updateGoals: false,
                                activate: false)));
                      } else {
                        Utilities.showBottomSheet(
                            isDismissable: false,
                            widget: UpdateProtocolGoalDialog(
                              clickedUpdate: (updateGoals) {
                                _bloc.add(UpdateProtocolGoalEvent(
                                    model: CustomizeProtocolActiveRequestEntity(
                                        protocolType: model.isTemplate ? ProtocolType.template.name : ProtocolType.custom.name,
                                        protocolId: int.parse(widget.protocol.id),
                                        updateGoals: updateGoals,
                                        activate: true)));
                              },
                            ),
                            context: context);
                      }
                    }))
          ],
        ),
      ),
    );
  }

  Widget _segmentedControlView() {
    return AppBoxedContainer(
      backgroundColor: Colors.transparent,
      borderSides: const [AppBorderSide.bottom],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SegmentedControlView(
          items: [
            SegmentedControlItem(
                onTapped: () {
                  _isShowingRotuine = true;
                  setState(() {});
                },
                unselectedBackgroundColor: Theme.of(context).colorScheme.secondaryElementColor.withValues(alpha: 0),
                selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                isSelected: _isShowingRotuine,
                index: 0,
                title: 'Routine'),
            SegmentedControlItem(
                onTapped: () {
                  _isShowingRotuine = false;
                  setState(() {});
                },
                isSelected: !_isShowingRotuine,
                index: 1,
                unselectedBackgroundColor: Theme.of(context).colorScheme.secondaryElementColor.withValues(alpha: 0),
                selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                title: 'Education'),
          ],
          size: 38,
        ),
      ),
    );
  }

  void _onStateChanged(ProtocolDetailsScreenState state, BuildContext context) {
    if (state is ProtocolDetailsFetchApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is DeleteUserProtocolState) {
      Utilities.showSnackBar(context, state.message.message, SnackbarStyle.success);
      // widget.bloc.add(FetchProtocolsListingEvent(FetchStyle.normal, null, ProtocolType.custom.name));
      widget.onRefreshedPage.call();
      Navigator.pop(context);
    } else if (state is FetchedProtocolDetailsState) {
      widget.onRefreshedPage.call();
    }
  }
}
