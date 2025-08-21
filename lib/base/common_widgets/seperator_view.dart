import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class SeperatorView extends StatelessWidget {
  const SeperatorView({this.seperatorColor, this.height, super.key});
  final Color? seperatorColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      color: seperatorColor ??
          Theme.of(context)
              .colorScheme
              .primaryElementInvertedeColor
              .withValues(alpha: 0.5),
    );
  }
}
