import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/week_one_traning_domain.dart';
import 'package:echowater/screens/goals_module/training_wrapper_view/training_wrapper_view.dart';
import 'package:flutter/material.dart';

class WeekTrainingWrapperView extends StatelessWidget {
  const WeekTrainingWrapperView(
      {required this.models, required this.currentDay, this.onClosePressed, this.onDayChanged, super.key});
  final List<WeekOneTraningDomain> models;
  final int currentDay;
  final Function()? onClosePressed;
  final Function(int day)? onDayChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, maxWidth: MediaQuery.of(context).size.width),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Text('Week_1_Training'.localized, style: Theme.of(context).textTheme.titleSmall),
                  NormalTextButton(
                    title: 'Close'.localized,
                    onClick: () {
                      onClosePressed?.call();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TrainingWrapperView(
                  models: models,
                  currentDay: currentDay,
                  updateWeekOneTraining: onClosePressed,
                  onDayChange: (day) {
                    onDayChanged?.call(day);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
