import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/profile_module/achievements_screen/bloc/achievements_screen_bloc.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/app_specific_widgets/goal_completion_share_view.dart';
import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/empty_state_view.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/AchievementsScreen'),
        builder: (_) => const AchievementsScreen());
  }
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _refreshController = RefreshController();
  late final AchievementsScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<AchievementsScreenBloc>();
    super.initState();
    _bloc.add(FetchMyWeekOneTrainingStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EchoWaterNavBar(
            child: NavBar(
          navStyle: NavStyle.singleLined,
          leftButton: const LeftArrowBackButton(),
          navTitle: 'AchievementsScreen_myAchievements'.localized,
          textColor: Theme.of(context).colorScheme.primaryElementColor,
        )),
        body: BlocConsumer<AchievementsScreenBloc, AchievementsScreenState>(
          bloc: _bloc,
          listener: (context, state) {
            _onStateChanged(state);
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: Loader());
            }
            return _mainContent();
          },
        ));
  }

  Widget _mainContent() {
    return Stack(
      children: [
        Visibility(
          visible: _bloc.achievements.isEmpty,
          child: Center(
            child: EmptyStateView(
              title: 'AchievementsScreen_noAchievements'.localized,
              tags: const [],
            ),
          ),
        ),
        SmartRefresher(
          controller: _refreshController,
          onRefresh: () async {
            await Utilities.vibrate();
            _bloc.add(FetchMyWeekOneTrainingStatsEvent());
          },
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _bloc.achievements.length,
              itemBuilder: (context, index) {
                final item = _bloc.achievements[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      AppImageView(
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                          cornerRadius: 5,
                          placeholderFit: BoxFit.contain,
                          placeholderHeight: 70,
                          placeholderWidth: 70,
                          placeholderImage: item.image),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  if (item.suffixText.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        item.suffixText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryElementColor),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: 10,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryElementColor,
                                  value: item.progress,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.subTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryElementColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (item.hasAcheived)
                        AppButton(
                          title: 'Share',
                          onClick: () {
                            Utilities.showBottomSheet(
                                widget: GoalCompletionShareView(
                                  title: item.shareMessage,
                                  image: item.shareImage,
                                ),
                                context: context);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          hasGradientBorder: true,
                          radius: 5,
                          width: 70,
                          height: 70,
                        )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  void _onStateChanged(AchievementsScreenState state) {
    if (state is AchievementsScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FetchedCurrentWeekOneTrainingState) {
      _bloc.add(FetchUsageStreakEvent());
    } else if (state is FetchedStatsState) {
      _refreshController.refreshCompleted();
    }
  }
}
