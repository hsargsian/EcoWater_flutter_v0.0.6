import 'package:bloc/bloc.dart';

import '../../../../core/domain/domain_models/usage_streak_domain.dart';
import '../../../../core/domain/domain_models/week_one_training_stat_domain.dart';
import '../../../../core/domain/entities/usage_streak_entity/usage_streak_entity.dart';
import '../../../../core/domain/repositories/goals_and_stats_repository.dart';

part 'achievements_screen_event.dart';
part 'achievements_screen_state.dart';

class AchievementsScreenBloc
    extends Bloc<AchievementsScreenEvent, AchievementsScreenState> {
  AchievementsScreenBloc({required GoalsAndStatsRepository repository})
      : _repository = repository,
        super(AchievementsScreenIdleState()) {
    on<FetchMyWeekOneTrainingStatsEvent>(_onFetchMyWeekOneTrainingStats);
    on<FetchUsageStreakEvent>(_onFetchUsageStreak);
  }
  final GoalsAndStatsRepository _repository;

  List<Achievement> achievements = [];

  UsageStreakDomain usageStreakDomain =
      UsageStreakDomain(UsageStreakEntity(0, 0, 0, 0, 0));

  late WeekOneTraningStatDomain weekOneTrainingStatsDomain;

  Future<void> _onFetchMyWeekOneTrainingStats(
      FetchMyWeekOneTrainingStatsEvent event,
      Emitter<AchievementsScreenState> emit) async {
    emit(LoadingState());
    final response = await _repository.fetchMyWeekOneTrainingStats();
    response.when(success: (response) {
      weekOneTrainingStatsDomain = WeekOneTraningStatDomain(response);

      emit(FetchedCurrentWeekOneTrainingState());
    }, error: (error) {
      emit(AchievementsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchUsageStreak(
    FetchUsageStreakEvent event,
    Emitter<AchievementsScreenState> emit,
  ) async {
    emit(LoadingState());
    final response = await _repository.fetchUsageStreak();
    response.when(success: (usageStreakEntity) {
      usageStreakDomain = UsageStreakDomain(usageStreakEntity);
      achievements =
          usageStreakDomain.getAchievementListing(weekOneTrainingStatsDomain);
      emit(FetchedStatsState());
    }, error: (error) {
      emit(AchievementsScreenApiErrorState(
        error.toMessage(),
      ));
    });
  }
}
