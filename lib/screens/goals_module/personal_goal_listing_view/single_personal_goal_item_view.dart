import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:echowater/screens/goals_module/personal_goal_listing_view/widget/circular_indicator.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class SinglePersonalGoalItemView extends StatelessWidget {
  const SinglePersonalGoalItemView(
      {required this.goal,
      required this.hasBottomBorder,
      required this.canPerformGoalOptions,
      required this.isFromGoalScreen,
      this.onMoreOptionButtonClick,
      super.key});

  final PersonalGoalDomain goal;
  final bool hasBottomBorder;
  final bool isFromGoalScreen;
  final bool canPerformGoalOptions;

  final Function(PersonalGoalDomain)? onMoreOptionButtonClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(goal.title),
            if (isFromGoalScreen)
              GestureDetector(
                  onTap: () {
                    onMoreOptionButtonClick?.call(goal);
                  },
                  child: Icon(color: Theme.of(context).colorScheme.primaryElementColor, Icons.more_vert))
          ],
        ),
        CircularIndicator(
            color: goal.progressColor(context),
            dotColor: goal.progressColor(context),
            value: goal.completed,
            totalValue: goal.total),
      ],
    );
  }
}
