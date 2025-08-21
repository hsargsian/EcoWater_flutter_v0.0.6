import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/domain_models/week_one_training_stat_domain.dart';
import '../../../core/domain/domain_models/week_one_traning_domain.dart';
import '../goal_completion_share_view.dart';
import 'week_training_wrapper_view.dart';

class WeekTrainingView extends StatelessWidget {
  const WeekTrainingView(
      {required this.weekOneTrainingStats,
      required this.trainingSet,
      this.onClosePressed,
      this.onDayChanged,
      this.onCrossPressed,
      super.key});
  final WeekOneTraningStatDomain weekOneTrainingStats;
  final List<WeekOneTraningDomain> trainingSet;
  final Function()? onClosePressed;
  final Function()? onCrossPressed;
  final Function(int day)? onDayChanged;

  @override
  Widget build(BuildContext context) {
    if (trainingSet.isEmpty || weekOneTrainingStats.hasClosedWeekTraining) {
      return const SizedBox.shrink();
    }
    if (weekOneTrainingStats.hasCompletedTraining()) {
      return _completedWeekTrainingView(context);
    }
    return AppBoxedContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Week_1_Training'.localized,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<int>.generate(7, (index) {
                return index + 1;
              }).toList().map((e) {
                return Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            child: Visibility(
                          visible: e != 1,
                          child: Container(
                            height: 5,
                            color: e <= (weekOneTrainingStats.currentDay)
                                ? const Color(0xff03A2B1)
                                : Colors.grey,
                          ),
                        )),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                  color: const Color(0xff03A2B1),
                                  width: e <= (weekOneTrainingStats.currentDay)
                                      ? 3
                                      : 0),
                              borderRadius: BorderRadius.circular(25)),
                          height: 40,
                          width: 40,
                          child: Center(
                              child: Text(
                            e.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        Expanded(
                            child: Visibility(
                          visible: e != 7,
                          child: Container(
                            height: 5,
                            color: e < (weekOneTrainingStats.currentDay)
                                ? const Color(0xff03A2B1)
                                : Colors.grey,
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weekOneTrainingStats.getCurrentDayText(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trainingSet[weekOneTrainingStats.currentDay].tagTitle,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      AppButton(
                          width: 100,
                          height: 30,
                          radius: 10,
                          hasGradientBorder: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          title: weekOneTrainingStats.currentDay < 1
                              ? 'Start'.localized
                              : 'Continue'.localized,
                          onClick: () {
                            _showWeekOneTrainingSheet(context);
                          })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showWeekOneTrainingSheet(BuildContext context) {
    Utilities.showBottomSheet(
        widget: WeekTrainingWrapperView(
            onClosePressed: onClosePressed,
            onDayChanged: (day) {
              onDayChanged?.call(day);
            },
            currentDay: weekOneTrainingStats.currentDay,
            models: trainingSet),
        context: context);
  }

  Widget _completedWeekTrainingView(BuildContext context) {
    return AppBoxedContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Week_1_Training'.localized,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onCrossPressed?.call();
                    },
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.secondaryElementColor,
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Congratulations'.localized,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You completed the Week 1 Training!'.localized,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )),
              AppButton(
                title: 'Share',
                hasGradientBorder: true,
                radius: 10,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                onClick: () {
                  Utilities.showBottomSheet(
                      widget: GoalCompletionShareView(
                        title: 'have completed the Week 1 Training!'.localized,
                        image: Images.weakTrainingAchievedAchievement,
                      ),
                      context: context);
                },
                width: 150,
              )
            ]),
            const Center(
              child: AppImageView(
                placeholderImage: Images.weakTrainingAchievementBanner,
                width: double.maxFinite,
                placeholderWidth: double.maxFinite,
                placeholderFit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
