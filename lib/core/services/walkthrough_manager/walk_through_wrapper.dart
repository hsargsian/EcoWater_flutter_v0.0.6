import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class WalkThroughWrapper extends StatelessWidget {
  WalkThroughWrapper(
      {required this.child,
      required this.hasWalkThough,
      this.clipRadius = 0,
      this.radius = 10,
      super.key});
  final Widget child;
  double clipRadius = 0;
  double radius = 10;
  bool hasWalkThough;

  @override
  Widget build(BuildContext context) {
    // always use container here.. dont change
    // ignore: use_decorated_box
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
                color: hasWalkThough
                    ? Theme.of(context).colorScheme.highLightColor
                    : Colors.transparent,
                width: hasWalkThough ? 3 : 0)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(clipRadius), child: child));
  }
}
