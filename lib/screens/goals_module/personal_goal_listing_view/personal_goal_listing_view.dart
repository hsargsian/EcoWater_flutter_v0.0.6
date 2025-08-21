import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/app_specific_widgets/goal_completion_share_view.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_option.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/screens/goals_module/add_update_personal_goal_screen/add_update_personal_goal_screen.dart';
import 'package:echowater/screens/goals_module/personal_goal_listing_view/bloc/personal_goal_listing_view_bloc.dart';
import 'package:echowater/screens/goals_module/personal_goal_listing_view/single_personal_goal_item_view.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/app_bottom_action_sheet_view.dart';
import '../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import '../../../base/app_specific_widgets/personal_goal_options_view.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';

class PersonalGoalListingView extends StatefulWidget {
  const PersonalGoalListingView({required this.date, required this.user, this.isFromGoalScreen = false, super.key});

  final DateTime date;
  final UserDomain user;
  final bool isFromGoalScreen;

  @override
  State<PersonalGoalListingView> createState() => PersonalGoalListingViewState();
}

class PersonalGoalListingViewState extends State<PersonalGoalListingView> {
  late final PersonalGoalListingViewBloc _bloc;

  bool isShowingGoalCompletion = false;
  late DateTime _selectedDate;
  late UserDomain _user;

  @override
  void initState() {
    _bloc = Injector.instance<PersonalGoalListingViewBloc>();
    super.initState();
    if (!widget.isFromGoalScreen) {
      setData(widget.date, widget.user);
    }
  }

  void setData(DateTime selectedDate, UserDomain user) {
    _selectedDate = selectedDate;
    _user = user;
    _bloc.add(FetchPersonalGoalsEvent(selectedDate, _user));
  }

  bool hasAddedPersonalGoal() {
    for (final item in _bloc.personalGoals) {
      if (!item.isDummyGoal) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final hasWalkThrough = WalkThroughManager().currentWalkthroughItem == WalkThroughItem.goalsPersonalGoals;
    return Column(
      children: [
        WalkThroughWrapper(
          clipRadius: hasWalkThrough ? 10 : 0,
          hasWalkThough: hasWalkThrough,
          child: AppBoxedContainer(
            borderSides: const [AppBorderSide.bottom, AppBorderSide.top],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PersonalGoals_title'.localized,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.secondaryElementColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<PersonalGoalListingViewBloc, PersonalGoalListingViewBlocState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      _onStateChanged(state, context);
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state is FetchingPersonalGoalsState
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
      ],
    );
  }

  Widget _singleItemGoalView(PersonalGoalDomain item, int index) {
    return item.isDummyGoal
        ? _createPersonalGoalView(item.addGoalTitle, item.bottlePPmType)
        : SinglePersonalGoalItemView(
            goal: item,
            canPerformGoalOptions: _bloc.isMyGoalList && item.canPerformGoalOptions,
            onMoreOptionButtonClick: (p0) {
              _showGoalOptionsBottomSheet(p0);
            },
            hasBottomBorder: false,
            isFromGoalScreen: widget.isFromGoalScreen,
          );
  }

  Widget _createPersonalGoalView(String title, BottleOrPPMType bottleOrPPMType) {
    return widget.isFromGoalScreen
        ? Column(
            children: [
              Align(alignment: Alignment.topLeft, child: Text(title)),
              const SizedBox(
                height: 36,
              ),
              Text(
                'PersonalGoals_create_goal'.localized,
                style:
                    Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.secondaryElementColor),
              ),
              IconButton(
                  iconSize: 30,
                  color: Theme.of(context).colorScheme.primaryElementColor,
                  onPressed: () {
                    Utilities.showBottomSheet(
                        widget: AddUpdatePersonalGoalScreen(
                            onGoalAddedUpdated: () {
                              _bloc.add(FetchPersonalGoalsEvent(_selectedDate, _user));
                            },
                            type: bottleOrPPMType),
                        context: context);
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded)),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _listView() {
    if (_bloc.personalGoals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('PersonalGoals_no_personal_goals'.localized),
        ),
      );
    }
    final lengthOfList =
        WalkThroughManager().hasSeenGoalsScreenWalkthrough ? _bloc.personalGoals.length : _bloc.dummyPersonalGoals.length;

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, crossAxisSpacing: 8),
      itemBuilder: (context, index) {
        final item =
            WalkThroughManager().hasSeenGoalsScreenWalkthrough ? _bloc.personalGoals[index] : _bloc.dummyPersonalGoals[index];
        final isDisplayVerticalDivider = index != lengthOfList - 1;

        return Row(
          children: [
            Expanded(child: _singleItemGoalView(item, index)),
            if (isDisplayVerticalDivider)
              VerticalDivider(
                thickness: 0.2,
                width: 0,
                color: Theme.of(context).colorScheme.secondaryElementColor,
              ),
          ],
        );
      },
      itemCount: lengthOfList,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _showGoalOptionsBottomSheet(PersonalGoalDomain goal) {
    Utilities.showBottomSheet(
        widget: PersonalGoalOptionsView(
          title: goal.actionsheetTitle,
          options: goal.getGoalOptions(),
          onItemClick: (option) {
            Navigator.pop(context);
            switch (option) {
              case PersonalGoalOption.shareCompletedGoal:
                _showShareGoalCompletion(goal);
              case PersonalGoalOption.deleteGoal:
                _showDeleteGoalAlert(goal);
                break;
              case PersonalGoalOption.editGoal:
                Utilities.showBottomSheet(
                    widget: AddUpdatePersonalGoalScreen(
                        onGoalAddedUpdated: () {
                          _bloc.add(FetchPersonalGoalsEvent(_selectedDate, _user));
                        },
                        goal: goal,
                        type: goal.bottlePPmType),
                    context: context);
                break;
            }
          },
        ),
        context: context);
  }

  Future<void> _showShareGoalCompletion(PersonalGoalDomain goal) async {
    Utilities.showBottomSheet(
        widget: GoalCompletionShareView(
          title: 'reached_bottle_goal'.localized,
          image: Images.weakTrainingAchievedAchievement,
        ),
        context: context);
  }

  void _showDeleteGoalAlert(PersonalGoalDomain goal) {
    Utilities.showBottomSheet(
        widget: AppBottomActionsheetView(
          title: goal.bottlePPmType.deleteActionSheetTitle,
          message: goal.bottlePPmType.deleteActionSheetMessage.localized,
          posiitiveButtonTitle: 'GoalOption_deleteGoalAlertYes'.localized,
          negativeButtonTitle: 'GoalOption_deleteGoalAlertNo'.localized,
          onNegativeButtonClick: () {
            Navigator.pop(context);
          },
          onPositiveButtonClick: () {
            Navigator.pop(context);
            _bloc.add(DeletePersonalGoalsEvent(goal));
          },
        ),
        context: context);
  }

  void _onStateChanged(PersonalGoalListingViewBlocState state, BuildContext context) {
    if (state is PersonalGoalListingViewApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is DeletedPersonalGoalState) {
      _bloc.add(FetchPersonalGoalsEvent(_selectedDate, _user));
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    }
  }
}
