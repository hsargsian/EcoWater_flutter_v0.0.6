import 'package:echowater/base/app_specific_widgets/app_bottom_action_sheet_view.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/app_boxed_container.dart';
import '../../../base/app_specific_widgets/personal_goal_options_view.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/personal_goal_option.dart';
import '../../../core/domain/domain_models/user_domain.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../../core/services/walkthrough_manager/walk_through_wrapper.dart';
import '../add_update_social_goal_screen/add_update_social_goal_screen.dart';
import 'bloc/social_goal_listing_view_bloc.dart';
import 'single_social_goal_item_view.dart';

class SocialGoalListingView extends StatefulWidget {
  const SocialGoalListingView(
      {required this.date,
      required this.user,
      this.isFromGoalScreen = false,
      super.key});
  final DateTime date;
  final UserDomain user;
  final bool isFromGoalScreen;

  @override
  State<SocialGoalListingView> createState() => SocialGoalListingViewState();
}

class SocialGoalListingViewState extends State<SocialGoalListingView> {
  late final SocialGoalListingViewBloc _bloc;
  late UserDomain _user;
  late DateTime _selectedDate;
  @override
  void initState() {
    _bloc = Injector.instance<SocialGoalListingViewBloc>();
    super.initState();
    if (!widget.isFromGoalScreen) {
      setData(widget.date, widget.user);
    }
  }

  void setData(DateTime selectedDate, UserDomain user) {
    _selectedDate = selectedDate;
    _user = user;
    _bloc.add(FetchSocialGoalsEvent(selectedDate, _user));
  }

  @override
  Widget build(BuildContext context) {
    final hasWalkthrough = WalkThroughManager().currentWalkthroughItem ==
        WalkThroughItem.goalsTeamGoals;
    return Column(
      children: [
        WalkThroughWrapper(
          clipRadius: hasWalkthrough ? 10 : 0,
          hasWalkThough: hasWalkthrough,
          child: AppBoxedContainer(
            borderSides: const [AppBorderSide.bottom, AppBorderSide.top],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<SocialGoalListingViewBloc,
                      SocialGoalListingViewBlocState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                              child: Text('SocialGoals_team_goal'.localized,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryElementColor))),
                          Visibility(
                              visible: _bloc.socialGoals
                                  .where((item) => item.isDummyGoal)
                                  .isEmpty,
                              child: _createGoalButtonView(null))
                        ],
                      );
                    },
                  ),
                  BlocConsumer<SocialGoalListingViewBloc,
                      SocialGoalListingViewBlocState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      _onStateChanged(state, context);
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state is FetchingSocialGoalsState
                              ? const Row(
                                  children: [
                                    Expanded(child: Center(child: Loader())),
                                  ],
                                )
                              : _listView(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: WalkThroughManager().currentWalkthroughItem ==
                  WalkThroughItem.goalsTeamGoals
              ? 250
              : 0,
        )
      ],
    );
  }

  void _onStateChanged(
      SocialGoalListingViewBlocState state, BuildContext context) {
    if (state is SocialGoalListingViewMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is DeletedSocialGoalState) {
      _bloc.add(FetchSocialGoalsEvent(_selectedDate, _user));
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    } else if (state is ReminderSentState) {
      _bloc.add(FetchSocialGoalsEvent(_selectedDate, _user));
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    }
  }

  bool hasAddedSocialGoal() {
    for (final item in _bloc.socialGoals) {
      if (!item.isDummyGoal) {
        return true;
      }
    }
    return false;
  }

  Widget _listView() {
    if (_bloc.socialGoals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('SocialGoals_no_social_goals'.localized),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final item = WalkThroughManager().hasSeenGoalsScreenWalkthrough
            ? _bloc.socialGoals[index]
            : _bloc.dummySocialGoals[index];

        if (item.isDummyGoal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_createGoalButtonView(null)],
          );
        } else {
          return SingleSocialGoalItemView(
              goal: item,
              isFromGoalScreen: widget.isFromGoalScreen,
              onMoreOptionButtonClick: (p0) {
                _showGoalOptionsBottomSheet(p0);
              },
              onSendReminderButtonClick: (p0) {
                _showRemindActionSheet(p0);
              },
              hasBottomBorder: index < (_bloc.socialGoals.length - 1));
        }
      },
      itemCount: WalkThroughManager().hasSeenGoalsScreenWalkthrough
          ? _bloc.socialGoals.length
          : _bloc.dummySocialGoals.length,
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _showRemindActionSheet(SocialGoalDomain goal) {
    Utilities.showBottomSheet(
        widget: AppBottomActionsheetView(
          title: 'SocialGoals_reminder_sent'.localized,
          message: goal.reminderSendActionSheetMessage.localized,
          posiitiveButtonTitle: 'Remind'.localized,
          negativeButtonTitle: 'Cancel'.localized,
          onNegativeButtonClick: () {
            Navigator.pop(context);
          },
          onPositiveButtonClick: () {
            Navigator.pop(context);
            _bloc.add(RemindSocialGoalEvent(goal));
          },
        ),
        context: context);
  }

  Widget _createGoalButtonView(SocialGoalDomain? item) {
    return Visibility(
      visible: _bloc.isMyGoalList &&
          _bloc.socialGoals.isNotEmpty &&
          !_selectedDate.isDateInPast,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SocialGoals_create_social_goal'.localized,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondaryElementColor),
          ),
          IconButton(
              iconSize: 30,
              color: Theme.of(context).colorScheme.primaryElementColor,
              onPressed: () {
                _openGoalDetail(item);
              },
              icon: const Icon(Icons.add_circle_outline_rounded))
        ],
      ),
    );
  }

  void _openGoalDetail(SocialGoalDomain? goal) {
    Utilities.showBottomSheet(
        widget: AddUpdateSocialGoalScreen(
            goal: goal,
            onGoalAddedUpdated: () {
              _bloc.add(FetchSocialGoalsEvent(_selectedDate, _user));
            },
            type: goal?.bottlePPmType),
        context: context);
  }

  void _showGoalOptionsBottomSheet(SocialGoalDomain goal) {
    final options = goal.getGoalOptions();
    if (options.isEmpty) {
      return;
    }
    Utilities.showBottomSheet(
        widget: PersonalGoalOptionsView(
          title: goal.actionsheetTitle,
          options: options,
          onItemClick: (option) {
            Navigator.pop(context);
            switch (option) {
              case PersonalGoalOption.shareCompletedGoal:
                break;
              case PersonalGoalOption.deleteGoal:
                _showDeleteGoalAlert(goal);
                break;
              case PersonalGoalOption.editGoal:
                _openGoalDetail(goal);
                break;
            }
          },
        ),
        context: context);
  }

  void _showDeleteGoalAlert(SocialGoalDomain goal) {
    Utilities.showBottomSheet(
        widget: AppBottomActionsheetView(
          title: 'GoalOption_deleteGoalAlertTitle'.localized,
          message: 'GoalOption_deleteSocialGoalAlertMessage'.localized,
          posiitiveButtonTitle: 'Delete'.localized,
          onNegativeButtonClick: () {
            Navigator.pop(context);
          },
          negativeButtonTitle: 'Cancel'.localized,
          onPositiveButtonClick: () {
            Navigator.pop(context);
            _bloc.add(DeleteSocialGoalsEvent(goal));
          },
        ),
        context: context);
  }
}
