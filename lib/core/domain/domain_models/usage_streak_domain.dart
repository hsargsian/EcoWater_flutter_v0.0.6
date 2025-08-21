import 'dart:math';

import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/usage_streak_entity/usage_streak_entity.dart';

import 'week_one_training_stat_domain.dart';

class UsageStreakDomain {
  UsageStreakDomain(this._entity);
  final UsageStreakEntity _entity;

  bool hasFetched = false;

  int get streak => _entity.usageStreak;

  String currentStreakText() {
    if (hasFetched) {
      final dayText =
          _entity.usageStreak > 1 ? 'days'.localized : 'day'.localized;
      return '${_entity.usageStreak} $dayText';
    }
    return '-';
  }

  String longestSreakText() {
    if (hasFetched) {
      final dayText =
          _entity.longestStreakCount > 1 ? 'days'.localized : 'day'.localized;
      final streakText = '${_entity.longestStreakCount} $dayText';
      return '${"longest_streak".localized} - $streakText';
    }
    return '-';
  }

  String get totalPPMs => hasFetched ? _entity.totalPPMs.toString() : '-';
  String get totalWater =>
      hasFetched ? _entity.totalWaterConsumed.toString() : '-';

  String get totalBottles => hasFetched ? _entity.totalBottles.toString() : '-';

  List<Achievement> getAchievementListing(
      WeekOneTraningStatDomain weekTrainingInfo) {
    final achievementListing = <Achievement>[];

    final currentStreak = _entity.usageStreak;
    final longestStreak = _entity.longestStreakCount;
    // final _ = List.generate(7, (index) {
    //   return index + 1;
    // })
    //   ..forEach((index) {
    //     final hasReachedDayStreak =
    //         currentStreak >= index || longestStreak >= index;
    //     achievementListing.add(Achievement(
    //         image: hasReachedDayStreak
    //             ? Images.streakAchievedAchievement
    //             : Images.streakNotAchievedAchievement,
    //         title: 'Day $index Streak',
    //         subTitle: hasReachedDayStreak ? '' : 'Reach a $index day streak',
    //         suffixText: hasReachedDayStreak
    //             ? ''
    //             : '${max(currentStreak, longestStreak)}/$index',
    //         progress: max(currentStreak, longestStreak) / index,
    //         hasAcheived: hasReachedDayStreak,
    //         isLocked: false,
    //         shareMessage:
    //             'have reached $index ${index == 1 ? 'day' : 'days'} streak'));
    //   });
    final hasCompletedWeekTraining = weekTrainingInfo.hasCompletedTraining();
    achievementListing.add(Achievement(
      image: Images.learningAchievementStreakThumbnailIcon,
      title: 'Complete Week 1 Training!',
      subTitle: hasCompletedWeekTraining
          ? 'Reached 7 day training'
          : 'Reach a 7 days training',
      suffixText:
          hasCompletedWeekTraining ? '' : '${weekTrainingInfo.currentDay}/7',
      progress: weekTrainingInfo.currentDay / 7,
      hasAcheived: hasCompletedWeekTraining,
      isLocked: !hasCompletedWeekTraining,
      shareMessage: 'have completed Week 1 Training',
      shareImage: Images.trainingAchievementAward,
    ));

    for (final index in [
      3,
      7,
      14,
      30,
      45,
      60,
      75,
      90,
      100,
      120,
      150,
      180,
      200,
      210,
      240,
      250,
      270,
      300,
      330,
      360
    ]) {
      final hasReachedDayStreak =
          currentStreak >= index || longestStreak >= index;
      achievementListing.add(
        Achievement(
            image: Images.goalStreakThumbnailIcon,
            title: 'Day $index Streak',
            subTitle: hasReachedDayStreak ? '' : 'Reach a $index day streak',
            suffixText: hasReachedDayStreak
                ? ''
                : '${max(currentStreak, longestStreak)}/$index',
            progress: max(currentStreak, longestStreak) / index,
            hasAcheived: hasReachedDayStreak,
            isLocked: false,
            shareMessage: 'have reached $index days streak',
            shareImage: '${Images.achievementsPath}$index.png'),
      );
    }
    return achievementListing;
  }
}

class Achievement {
  Achievement(
      {required this.image,
      required this.title,
      required this.subTitle,
      required this.suffixText,
      required this.progress,
      required this.hasAcheived,
      required this.isLocked,
      required this.shareMessage,
      required this.shareImage});
  final String image;
  final String title;
  final String subTitle;
  final String suffixText;
  final double progress;
  final bool hasAcheived;
  final bool isLocked;
  final String shareMessage;
  final String shareImage;
}
