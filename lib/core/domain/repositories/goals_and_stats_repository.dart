import 'package:echowater/core/domain/entities/personal_goal_entity/personal_goal_entity.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_entity.dart';
import 'package:echowater/core/domain/entities/todays_progress_entity/todays_progress_entity.dart';
import 'package:echowater/core/domain/entities/usage_dates_entity/usage_dates_entity.dart';
import 'package:echowater/core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_entity.dart';
import '../../api/resource/resource.dart';
import '../entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../entities/personal_goal_graph_entity/personal_goal_graph_entity.dart';
import '../entities/week_one_traning_entity/week_one_training_stat_entity.dart';

abstract class GoalsAndStatsRepository {
  Future<Result<List<WeekOneTraningEntity>>> fetchWeekOneTrainingSet();
  Future<Result<WeekOneTrainingStatEntity>> fetchMyWeekOneTrainingStats();
  Future<Result<bool>> updateWeekOneTrainingViewState({required int currentDay});
  Future<Result<bool>> closeWeekOneTrainingView();
  Future<Result<List<PersonalGoalEntity>>> fetchPersonalGoals({required String date, required String userId});
  Future<Result<ApiSuccessMessageResponseEntity>> deletePersonalGoal({required String goalId});
  Future<Result<ApiSuccessMessageResponseEntity>> addNewPersonalGoal({required String goalType, required int goalNumber});
  Future<Result<ApiSuccessMessageResponseEntity>> updatePersonalGoal(
      {required String goalId, required String goalType, required int goalNumber});

  Future<Result<List<SocialGoalEntity>>> fetchSocialGoals({required String date, required String userId});
  Future<Result<ApiSuccessMessageResponseEntity>> addNewSocialGoal(
      {required String name, required String goalType, required int goalNumber, required List<String> participants});
  Future<Result<ApiSuccessMessageResponseEntity>> deleteSocialGoal({required String goalId});

  Future<Result<ApiSuccessMessageResponseEntity>> remindSocialGoal({required String goalId, required String friendId});
  Future<Result<ApiSuccessMessageResponseEntity>> updateSocialGoal(
      {required String goalId,
      required String name,
      required String goalType,
      required int goalNumber,
      required List<String> participants});

  Future<Result<UsageDatesEntity>> fetchUsageDates({required String startDate, required String endDate});
  Future<Result<TodaysProgressEntity>> fetchTodayProgress();
  Future<Result<UsageStreakEntity>> fetchUsageStreak();
  Future<Result<List<PersonalGoalGraphEntity>>> fetchPersonalGoalGraphEntity(
      {required String startDate, required String endDate, required String goalType});

  Future<Result<ApiSuccessMessageResponseEntity>> addWaterConsumption({required int volume});
}
