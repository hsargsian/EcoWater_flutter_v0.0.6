import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/todays_progress_domain.dart';
import 'package:echowater/screens/goals_module/add_water_screen/add_water_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common_widgets/buttons/app_button.dart';
import '../../common_widgets/gradient_circular_progress_iIndicator.dart';
import '../../utils/colors.dart';
import '../../utils/utilities.dart';

class TodayProgressView extends StatelessWidget {
  TodayProgressView(
      {required this.todayProgress, this.onAdditionSuccess, super.key});

  void Function()? onAdditionSuccess;

  final TodaysProgressDomain todayProgress;

  Widget _placeholder(BuildContext context) {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 25, left: 20, right: 20),
        child: Shimmer.fromColors(
          baseColor: AppColors.color717171Base,
          highlightColor: AppColors.color717171Base.withValues(alpha: 0.8),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  height: 30,
                  width: 100,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return todayProgress.hasFetched
        ? AppBoxedContainer(
            borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Todays_Progress'.localized,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      AppButton(
                          height: 30,
                          width: 110,
                          icon: const Icon(
                            Icons.add,
                            size: 15,
                          ),
                          hasGradientBackground: true,
                          title: 'Add Water'.localized,
                          onClick: () {
                            Utilities.showBottomSheet(
                                widget: AddWaterConsumptionScreen(
                                  onAdditionSuccess: onAdditionSuccess,
                                ),
                                context: context);
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                        child: _singleItem(
                            context,
                            todayProgress.bottleConsumed,
                            todayProgress.bottleTotal,
                            'Flasks',
                            'Quantity'.localized,
                            Theme.of(context).colorScheme.highLightColor)),
                    Expanded(
                        child: _singleItem(
                            context,
                            todayProgress.ppmConsumed,
                            todayProgress.ppmTotal,
                            'H2',
                            'Milligrams'.localized,
                            Theme.of(context).colorScheme.primary)),
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                      height: 60,
                    ),
                    Expanded(
                        child: _singleItem(
                            context,
                            todayProgress.waterConsumed,
                            todayProgress.waterTotal,
                            'Water',
                            'Ounces'.localized,
                            HexColor.fromHex('#7FA0AC'))),
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ))
        : _placeholder(context);
  }

  Widget _singleItem(BuildContext context, num value, int totalValue,
      String suffix, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GradientCircularProgressIndicator(
                radius: 50,
                gradientColors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.9),
                  color
                ],
                value: value / totalValue,
              ),
              Container(),
              Positioned(
                top: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$value',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryElementColor),
                      ),
                      Container(
                        height: 3,
                        width: 50,
                        color: color,
                      ),
                      Text(
                        '$totalValue',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryElementColor),
                      ),
                    ],
                  ),
                )),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            suffix,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondaryElementColor),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.secondaryElementColor,
                fontSize: 8),
          )
        ],
      ),
    );
  }
}

// class GradientCircularProgressIndicator extends StatelessWidget {
//   const GradientCircularProgressIndicator({
//     required this.radius,
//     required this.gradientColors,
//     super.key,
//     this.strokeWidth = 10.0,
//   });
//   final double radius;
//   final List<Color> gradientColors;
//   final double strokeWidth;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size.fromRadius(radius),
//       painter: GradientCircularProgressPainter(
//         radius: radius,
//         gradientColors: gradientColors,
//         strokeWidth: strokeWidth,
//       ),
//     );
//   }
// }
//
// class GradientCircularProgressPainter extends CustomPainter {
//   GradientCircularProgressPainter({
//     required this.radius,
//     required this.gradientColors,
//     required this.strokeWidth,
//   });
//   final double radius;
//   final List<Color> gradientColors;
//   final double strokeWidth;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     size = Size.fromRadius(radius);
//     final offset = strokeWidth / 2;
//     final rect = Offset(offset, offset) &
//         Size(size.width - strokeWidth, size.height - strokeWidth);
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..shader = SweepGradient(colors: gradientColors).createShader(rect);
//     canvas.drawArc(rect, 0, 2 * pi, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
