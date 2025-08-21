import 'package:echowater/core/data/data_sources/goals_and_stats_data_sources/goals_and_stats_local_data_source.dart';
import 'package:echowater/core/data/data_sources/goals_and_stats_data_sources/goals_and_stats_remote_data_source.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/personal_goal_entity/personal_goal_entity.dart';
import 'package:echowater/core/domain/entities/personal_goal_graph_entity/personal_goal_graph_entity.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_entity.dart';
import 'package:echowater/core/domain/entities/usage_dates_entity/usage_dates_entity.dart';
import 'package:echowater/core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_training_stat_entity.dart';
import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_entity.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/todays_progress_entity/todays_progress_entity.dart';
import '../../domain/repositories/goals_and_stats_repository.dart';

class GoalsAndStatsRepositoryImpl implements GoalsAndStatsRepository {
  GoalsAndStatsRepositoryImpl(
      {required GoalsAndStatsRemoteDataSource remoteDataSource, required GoalsAndStatsLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final GoalsAndStatsRemoteDataSource _remoteDataSource;
  final GoalsAndStatsLocalDataSource _localDataSource;

  @override
  Future<Result<List<WeekOneTraningEntity>>> fetchWeekOneTrainingSet() async {
    try {
      final response = (await _remoteDataSource.fetchWeekOneTraningSet()).map((e) => e.asEntity()).toList()
        ..sort((a, b) {
          return a.day < b.day ? -1 : 1;
        });
      return Result.success(response);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> updateWeekOneTrainingViewState({required int currentDay}) async {
    try {
      await _remoteDataSource.updateWeekOneTrainingViewState(currentDay: currentDay);

      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PersonalGoalEntity>>> fetchPersonalGoals({required String date, required String userId}) async {
    try {
      final response = await _remoteDataSource.fetchPersonalGoals(date: date, userId: userId);

      return Result.success(response.map((item) => item.asEntity()).toList());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> addNewPersonalGoal({required String goalType, required int goalNumber}) async {
    try {
      final response = await _remoteDataSource.addNewPersonalGoal(goalType: goalType, goalNumber: goalNumber);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> deletePersonalGoal({required String goalId}) async {
    try {
      final response = await _remoteDataSource.deletePersonalGoal(goalId: goalId);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> updatePersonalGoal(
      {required String goalId, required String goalType, required int goalNumber}) async {
    try {
      final response = await _remoteDataSource.updatePersonalGoal(goalId: goalId, goalType: goalType, goalNumber: goalNumber);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<WeekOneTrainingStatEntity>> fetchMyWeekOneTrainingStats() async {
    try {
      final response = await _remoteDataSource.fetchMyWeekOneTraningStats();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UsageDatesEntity>> fetchUsageDates({required String startDate, required String endDate}) async {
    try {
      final response = await _remoteDataSource.fetchUsageDates(startDate: startDate, endDate: endDate);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<TodaysProgressEntity>> fetchTodayProgress() async {
    try {
      final response = await _remoteDataSource.fetchTodaysProgress();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UsageStreakEntity>> fetchUsageStreak() async {
    try {
      final response = await _remoteDataSource.fetchUsageStreak();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<PersonalGoalGraphEntity>>> fetchPersonalGoalGraphEntity(
      {required String startDate, required String endDate, required String goalType}) async {
    try {
      final response =
          await _remoteDataSource.fetchPersonalGoalGraphData(startDate: startDate, endDate: endDate, goalType: goalType);
      return Result.success(response.map((item) => item.asEntity()).toList());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<SocialGoalEntity>>> fetchSocialGoals({required String date, required String userId}) async {
    try {
      final response = await _remoteDataSource.fetchSocialGoals(date: date, userId: userId);

      return Result.success(response.map((item) => item.asEntity()).toList());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> deleteSocialGoal({required String goalId}) async {
    try {
      final response = await _remoteDataSource.deleteSocialGoal(goalId: goalId);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> addNewSocialGoal(
      {required String name, required String goalType, required int goalNumber, required List<String> participants}) async {
    try {
      final response = await _remoteDataSource.addNewSocialGoal(
          name: name, goalType: goalType, goalNumber: goalNumber, participants: participants);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> updateSocialGoal(
      {required String goalId,
      required String name,
      required String goalType,
      required int goalNumber,
      required List<String> participants}) async {
    try {
      final response = await _remoteDataSource.updateSocialGoal(
          goalId: goalId, name: name, goalType: goalType, goalNumber: goalNumber, participants: participants);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> remindSocialGoal({required String goalId, required String friendId}) async {
    try {
      final response = await _remoteDataSource.remindSocialGoal(goalId: goalId, friendId: friendId);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> closeWeekOneTrainingView() async {
    try {
      await _remoteDataSource.closeWeekOneTrainingView();

      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> addWaterConsumption({required int volume}) async {
    try {
      final response = await _remoteDataSource.addWaterConsumption(volume: volume);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
