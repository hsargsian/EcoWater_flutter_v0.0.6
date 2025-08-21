import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/empty_success_response/api_success_message_response.dart';
import 'package:echowater/core/api/models/personal_goal_data/personal_goal_data.dart';
import 'package:echowater/core/api/models/social_goal_data/social_goal_data.dart';
import 'package:echowater/core/api/models/todays_progress_data/todays_progress_data.dart';
import 'package:echowater/core/api/models/usage_dates_data/usage_dates_data.dart';
import 'package:echowater/core/api/models/usage_streak_data/usage_streak_data.dart';
import 'package:echowater/core/api/models/week_one_traning_data/week_one_training_data.dart';
import 'package:echowater/core/api/models/week_one_traning_data/week_one_training_stat_data.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/personal_goal_graph_data/personal_goal_graph_data.dart';

abstract class GoalsAndStatsRemoteDataSource {
  Future<List<WeekOneTraningData>> fetchWeekOneTraningSet();
  Future<WeekOneTraningStatData> fetchMyWeekOneTraningStats();

  Future<WeekOneTraningStatData> updateWeekOneTrainingViewState({required int currentDay});

  Future<ApiSuccessMessageResponse> closeWeekOneTrainingView();
  Future<ApiSuccessMessageResponse> addNewPersonalGoal({required String goalType, required int goalNumber});
  Future<ApiSuccessMessageResponse> updatePersonalGoal(
      {required String goalId, required String goalType, required int goalNumber});
  Future<List<PersonalGoalData>> fetchPersonalGoals({required String date, required String userId});
  Future<ApiSuccessMessageResponse> deletePersonalGoal({required String goalId});

  Future<ApiSuccessMessageResponse> addNewSocialGoal(
      {required String name, required String goalType, required int goalNumber, required List<String> participants});

  Future<ApiSuccessMessageResponse> updateSocialGoal(
      {required String goalId,
      required String name,
      required String goalType,
      required int goalNumber,
      required List<String> participants});
  Future<List<SocialGoalData>> fetchSocialGoals({required String date, required String userId});
  Future<ApiSuccessMessageResponse> deleteSocialGoal({required String goalId});
  Future<ApiSuccessMessageResponse> remindSocialGoal({required String goalId, required String friendId});
  Future<UsageDatesData> fetchUsageDates({required String startDate, required String endDate});
  Future<TodaysProgressData> fetchTodaysProgress();
  Future<UsageStreakData> fetchUsageStreak();
  Future<List<PersonalGoalGraphData>> fetchPersonalGoalGraphData(
      {required String startDate, required String endDate, required String goalType});
  Future<ApiSuccessMessageResponse> addWaterConsumption({required int volume});
}

class GoalsAndStatsRemoteDataSourceImpl extends GoalsAndStatsRemoteDataSource {
  GoalsAndStatsRemoteDataSourceImpl({required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchWeekOneTraningSetCancelToken = CancelToken();
  CancelToken _updateWeekOneTraningSetCancelToken = CancelToken();
  CancelToken _fetchPersonalGoalCancelToken = CancelToken();
  CancelToken _fetchSocialGoalCancelToken = CancelToken();
  CancelToken _deleteSocialGoalCancelToken = CancelToken();
  CancelToken _deletePersonalGoalCancelToken = CancelToken();
  CancelToken _addPersonalGoalCancelToken = CancelToken();
  CancelToken _addSocialGoalCancelToken = CancelToken();
  CancelToken _updateSocialGoalCancelToken = CancelToken();
  CancelToken _remindSocialGoalCancelToken = CancelToken();
  CancelToken _fetchMyWeekOneTrainingStatsCancelToken = CancelToken();
  CancelToken _fetchUsageDatesCancelToken = CancelToken();
  CancelToken _fetchPersonalGoalGraphDataCancelToken = CancelToken();

  @override
  Future<List<WeekOneTraningData>> fetchWeekOneTraningSet() async {
    try {
      _fetchWeekOneTraningSetCancelToken.cancel();
      _fetchWeekOneTraningSetCancelToken = CancelToken();
      return (await _authorizedApiClient.fetchWeekOneTraningSet()).results;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<WeekOneTraningStatData> updateWeekOneTrainingViewState({required int currentDay}) async {
    try {
      _updateWeekOneTraningSetCancelToken.cancel();
      _updateWeekOneTraningSetCancelToken = CancelToken();
      return await _authorizedApiClient.updateWeekOneTrainingViewState(currentDay);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> addNewPersonalGoal({required String goalType, required int goalNumber}) async {
    try {
      _addPersonalGoalCancelToken.cancel();
      _addPersonalGoalCancelToken = CancelToken();
      return await _authorizedApiClient.addPersonalGoal(goalType, goalNumber, _addPersonalGoalCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<PersonalGoalData>> fetchPersonalGoals({required String date, required String userId}) async {
    try {
      _fetchPersonalGoalCancelToken.cancel();
      _fetchPersonalGoalCancelToken = CancelToken();
      return (await _authorizedApiClient.fetchPersonalGoals(userId, date, _fetchPersonalGoalCancelToken)).personalGoals;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> deletePersonalGoal({required String goalId}) async {
    try {
      _deletePersonalGoalCancelToken.cancel();
      _deletePersonalGoalCancelToken = CancelToken();
      return await _authorizedApiClient.deletePersonalGoal(goalId, _deletePersonalGoalCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> updatePersonalGoal(
      {required String goalId, required String goalType, required int goalNumber}) async {
    try {
      _addPersonalGoalCancelToken.cancel();
      _addPersonalGoalCancelToken = CancelToken();
      return await _authorizedApiClient.addPersonalGoal(goalType, goalNumber, _addPersonalGoalCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<WeekOneTraningStatData> fetchMyWeekOneTraningStats() async {
    try {
      _fetchMyWeekOneTrainingStatsCancelToken.cancel();
      _fetchMyWeekOneTrainingStatsCancelToken = CancelToken();
      return await _authorizedApiClient.fetchWeekOneTraningStats(_fetchMyWeekOneTrainingStatsCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UsageDatesData> fetchUsageDates({required String startDate, required String endDate}) async {
    try {
      _fetchUsageDatesCancelToken.cancel();
      _fetchUsageDatesCancelToken = CancelToken();
      return await _authorizedApiClient.fetchUsageDates(startDate, endDate, _fetchUsageDatesCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<TodaysProgressData> fetchTodaysProgress() async {
    try {
      _fetchUsageDatesCancelToken.cancel();
      _fetchUsageDatesCancelToken = CancelToken();
      return await _authorizedApiClient.fetchTodaysProgress(_fetchUsageDatesCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UsageStreakData> fetchUsageStreak() async {
    try {
      _fetchUsageDatesCancelToken.cancel();
      _fetchUsageDatesCancelToken = CancelToken();
      return await _authorizedApiClient.fetchUsageStreak(_fetchUsageDatesCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<PersonalGoalGraphData>> fetchPersonalGoalGraphData(
      {required String startDate, required String endDate, required String goalType}) async {
    try {
      _fetchPersonalGoalGraphDataCancelToken.cancel();
      _fetchPersonalGoalGraphDataCancelToken = CancelToken();
      return await _authorizedApiClient.fetchPersonalGoalGraphData(
          startDate, endDate, goalType, _fetchPersonalGoalGraphDataCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> deleteSocialGoal({required String goalId}) async {
    try {
      _deleteSocialGoalCancelToken.cancel();
      _deleteSocialGoalCancelToken = CancelToken();
      return await _authorizedApiClient.deleteSocialGoal(goalId, _deleteSocialGoalCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<SocialGoalData>> fetchSocialGoals({required String date, required String userId}) async {
    try {
      _fetchSocialGoalCancelToken.cancel();
      _fetchSocialGoalCancelToken = CancelToken();
      return (await _authorizedApiClient.fetchSocialGoals(userId, date, _fetchSocialGoalCancelToken)).socialGoals;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> addNewSocialGoal(
      {required String name, required String goalType, required int goalNumber, required List<String> participants}) async {
    try {
      _addSocialGoalCancelToken.cancel();
      _addSocialGoalCancelToken = CancelToken();
      await _authorizedApiClient.addSocialGoal(goalType, goalNumber, participants, name, _addSocialGoalCancelToken);
      return Future.value(ApiSuccessMessageResponse('Added'));
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> updateSocialGoal(
      {required String goalId,
      required String name,
      required String goalType,
      required int goalNumber,
      required List<String> participants}) async {
    try {
      _updateSocialGoalCancelToken.cancel();
      _updateSocialGoalCancelToken = CancelToken();
      await _authorizedApiClient.updateSocialGoal(goalId, goalType, goalNumber, participants, name, _updateSocialGoalCancelToken);
      return Future.value(ApiSuccessMessageResponse('Updated'));
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> remindSocialGoal({required String goalId, required String friendId}) async {
    try {
      _remindSocialGoalCancelToken.cancel();
      _remindSocialGoalCancelToken = CancelToken();
      return await _authorizedApiClient.remindSocialGoal(goalId, friendId, _remindSocialGoalCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> closeWeekOneTrainingView() async {
    try {
      return await _authorizedApiClient.closeWeekOneTrainingView();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> addWaterConsumption({required int volume}) async {
    try {
      return await _authorizedApiClient.addWaterConsumption(volume);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
