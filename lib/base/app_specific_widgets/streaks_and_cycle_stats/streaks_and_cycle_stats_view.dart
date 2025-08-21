import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/usage_streak_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/colors.dart';

class StreaksAndCycleStatsView extends StatelessWidget {
  const StreaksAndCycleStatsView({required this.usageStreak, super.key});
  final UsageStreakDomain usageStreak;

  Widget _placeholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppBoxedContainer(
        borderSides: const [AppBorderSide.bottom],
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 25, left: 20, right: 20),
          child: Shimmer.fromColors(
            baseColor: AppColors.color717171Base,
            highlightColor: AppColors.color717171Base.withValues(alpha: 0.8),
            child: Column(
                children: List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: List.generate(2, (jIndex) {
                    return _singleShimmer(context);
                  }).toList(),
                ),
              );
            }).toList()),
          ),
        ),
      ),
    );
  }

  Widget _singleShimmer(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            height: 120,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return usageStreak.hasFetched
        ? AppBoxedContainer(
            borderSides: const [
                AppBorderSide.top,
              ],
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _singleItemView(
                    context,
                    usageStreak.currentStreakText(),
                    'Current_Streak'.localized,
                    Images.streakOutlinedIcon,
                    bottomWidget: Text(
                      usageStreak.longestSreakText(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _singleItemView(
                              context,
                              usageStreak.totalBottles,
                              'toal_bottles_consumed'.localized,
                              Images.cyclesCompletedIcon,
                              textColor:
                                  Theme.of(context).colorScheme.primary)),
                      Expanded(
                          child: _singleItemView(
                              context,
                              '${usageStreak.totalPPMs}${'mg'.localized}',
                              'toal_h2_consumed'.localized,
                              Images.hydrogenIconSVG,
                              textColor:
                                  Theme.of(context).colorScheme.primary)),
                      Expanded(
                          child: _singleItemView(
                              context,
                              '${usageStreak.totalWater}${'oz'.localized}',
                              'total_water_consumed'.localized,
                              Images.waterIconSVG,
                              textColor:
                                  Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                ],
              ),
            ))
        : _placeholder(context);
  }

  Widget _singleItemView(
      BuildContext context, String title, String detailText, String iconImage,
      {Color? color, Widget? bottomWidget, Color? textColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).colorScheme.primaryElementColor,
              width: 0.5)),
      child: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconImage,
              height: 30,
              colorFilter: ColorFilter.mode(
                  color ?? Theme.of(context).colorScheme.primaryElementColor,
                  BlendMode.srcIn),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: textColor ??
                      Theme.of(context).colorScheme.primaryElementColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              detailText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondaryElementColor),
            ),
            if (bottomWidget != null)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: bottomWidget,
              )
          ],
        ),
      ),
    );
  }
}
