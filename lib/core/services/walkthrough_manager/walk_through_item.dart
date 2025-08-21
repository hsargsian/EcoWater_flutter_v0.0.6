import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_screen_item.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../base/common_widgets/buttons/app_button.dart';
import 'walk_through_manager.dart';

enum WalkThroughItem {
  none,
  homeBase,
  homeBottleAndPpm,
  homeProgress,
  homeConsumptionProgress,
  homeNotification,
  profileEditProfile,
  profileSettingsOptions,
  learningCategory,
  learningSupport,
  goalsWeekTraining,
  goalsPersonalGoals,
  goalsTeamGoals;

  String title(String name) {
    switch (this) {
      case WalkThroughItem.none:
        return '';
      case WalkThroughItem.homeBase:
        return '${"walkthrough_item_homebase_title".localized} $name';
      case WalkThroughItem.homeBottleAndPpm:
        return 'walkthrough_item_homeBottleAndPpm_title'.localized;
      case WalkThroughItem.homeProgress:
        return 'walkthrough_item_homeProgress_title'.localized;
      case WalkThroughItem.homeConsumptionProgress:
        return 'walkthrough_item_homeConsumptionProgress_title'.localized;
      case WalkThroughItem.homeNotification:
        return 'walkthrough_item_homeNotification_title'.localized;

      case WalkThroughItem.profileEditProfile:
        return 'walkthrough_item_profileEditProfile_title'.localized;
      case WalkThroughItem.profileSettingsOptions:
        return 'walkthrough_item_profileSettingsOptions_title'.localized;
      case WalkThroughItem.learningCategory:
        return 'walkthrough_item_learningCategory_title'.localized;
      case WalkThroughItem.learningSupport:
        return 'walkthrough_item_learningSupport_title'.localized;

      case WalkThroughItem.goalsWeekTraining:
        return 'walkthrough_item_goalsWeekTraining_title'.localized;
      case WalkThroughItem.goalsPersonalGoals:
        return 'walkthrough_item_goalsPersonalGoals_title'.localized;
      case WalkThroughItem.goalsTeamGoals:
        return 'walkthrough_item_goalsTeamGoals_title'.localized;
    }
  }

  Widget buttonView(BuildContext context, WalkThroughScreenItem screenItem) {
    switch (this) {
      case WalkThroughItem.none:
        return const SizedBox.shrink();
      case WalkThroughItem.homeBase:
        return AppButton(
            elevation: 0,
            hasGradientBackground: true,
            title: 'Begin'.localized,
            onClick: () {
              WalkThroughManager().nextWalkThrough(screenItem);
            });
      case WalkThroughItem.homeBottleAndPpm:
      case WalkThroughItem.homeProgress:
      case WalkThroughItem.homeConsumptionProgress:
      case WalkThroughItem.goalsPersonalGoals:
        return Row(
          children: [
            Expanded(
              child: AppButton(
                  backgroundColor: Theme.of(context).colorScheme.highLightColor,
                  border: BorderSide(
                      color: Theme.of(context).colorScheme.primaryElementColor),
                  elevation: 0,
                  title: 'Back'.localized,
                  onClick: () {
                    WalkThroughManager().previousWalkThrough(screenItem);
                  }),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: AppButton(
                  elevation: 0,
                  hasGradientBackground: true,
                  title: 'Next'.localized,
                  onClick: () {
                    WalkThroughManager().nextWalkThrough(screenItem);
                  }),
            )
          ],
        );
      case WalkThroughItem.homeNotification:
      case WalkThroughItem.profileSettingsOptions:
      case WalkThroughItem.learningSupport:
      case WalkThroughItem.goalsTeamGoals:
        return AppButton(
            elevation: 0,
            hasGradientBackground: true,
            title: 'complete'.localized,
            onClick: () {
              WalkThroughManager().nextWalkThrough(screenItem);
            });

      case WalkThroughItem.profileEditProfile:
      case WalkThroughItem.learningCategory:
      case WalkThroughItem.goalsWeekTraining:
        return AppButton(
            elevation: 0,
            hasGradientBackground: true,
            title: 'Next'.localized,
            onClick: () {
              WalkThroughManager().nextWalkThrough(screenItem);
            });
    }
  }

  double get offset {
    switch (this) {
      case WalkThroughItem.none:
      case WalkThroughItem.homeBase:
      case WalkThroughItem.homeNotification:
      case WalkThroughItem.profileEditProfile:
      case WalkThroughItem.profileSettingsOptions:
      case WalkThroughItem.learningCategory:
      case WalkThroughItem.learningSupport:
      case WalkThroughItem.goalsWeekTraining:
        return 0;
      case WalkThroughItem.homeBottleAndPpm:
        return 300;
      case WalkThroughItem.homeProgress:
        return 850;
      case WalkThroughItem.homeConsumptionProgress:
        return 550;
      case WalkThroughItem.goalsPersonalGoals:
        return 350;
      case WalkThroughItem.goalsTeamGoals:
        return 550;
    }
  }

  String get counter {
    switch (this) {
      case WalkThroughItem.none:
        return '';
      case WalkThroughItem.homeBase:
        return '';
      case WalkThroughItem.homeBottleAndPpm:
        return '1/4';
      case WalkThroughItem.homeProgress:
        return '2/4';
      case WalkThroughItem.homeConsumptionProgress:
        return '3/4';
      case WalkThroughItem.homeNotification:
        return '4/4';

      case WalkThroughItem.profileEditProfile:
      case WalkThroughItem.learningCategory:
        return '1/2';
      case WalkThroughItem.profileSettingsOptions:
      case WalkThroughItem.learningSupport:
        return '2/2';
      case WalkThroughItem.goalsWeekTraining:
        return '1/3';
      case WalkThroughItem.goalsPersonalGoals:
        return '2/3';
      case WalkThroughItem.goalsTeamGoals:
        return '3/3';
    }
  }

  String get description {
    switch (this) {
      case WalkThroughItem.none:
        return '';
      case WalkThroughItem.homeBase:
        return 'walkthrough_item_homebase_description'.localized;
      case WalkThroughItem.homeBottleAndPpm:
        return 'walkthrough_item_homeBottleAndPpm_description'.localized;
      case WalkThroughItem.homeProgress:
        return 'walkthrough_item_homeProgress_description'.localized;
      case WalkThroughItem.homeConsumptionProgress:
        return 'walkthrough_item_homeConsumptionProgress_description'.localized;
      case WalkThroughItem.homeNotification:
        return 'walkthrough_item_homeNotification_description'.localized;

      case WalkThroughItem.profileEditProfile:
        return 'walkthrough_item_profileEditProfile_description'.localized;
      case WalkThroughItem.profileSettingsOptions:
        return 'walkthrough_item_profileSettingsOptions_description'.localized;
      case WalkThroughItem.learningCategory:
        return 'walkthrough_item_learningCategory_description'.localized;
      case WalkThroughItem.learningSupport:
        return 'walkthrough_item_learningSupport_description'.localized;
      case WalkThroughItem.goalsWeekTraining:
        return 'walkthrough_item_goalsWeekTraining_description'.localized;
      case WalkThroughItem.goalsPersonalGoals:
        return 'walkthrough_item_goalsPersonalGoals_description'.localized;
      case WalkThroughItem.goalsTeamGoals:
        return 'walkthrough_item_goalsTeamGoals_description'.localized;
    }
  }
}
