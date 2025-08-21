import 'package:flutter/material.dart';

import '../../../../base/common_widgets/gradient_circular_progress_iIndicator.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator(
      {required this.color,
      required this.value,
      required this.totalValue,
      this.dotColor,
      super.key});

  final Color color;
  final num value;
  final int totalValue;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientCircularProgressIndicator(
            radius: 50,
            value: value / totalValue,
            gradientColors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.9),
              color
            ],
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: dotColor ?? Colors.transparent)),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w400, color: color),
                  ),
                  Container(
                    height: 3,
                    width: 50,
                    color: color,
                  ),
                  Text(
                    '$totalValue',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w400, color: color),
                  ),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
