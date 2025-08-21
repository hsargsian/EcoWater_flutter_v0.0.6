import 'package:echowater/base/utils/colors.dart';
import 'package:flutter/material.dart';

class AppBoxedContainer extends StatelessWidget {
  const AppBoxedContainer(
      {required this.child,
      this.backgroundColor,
      this.borderSides,
      this.borderColor,
      this.borderWidth,
      super.key});
  final Widget child;
  final Color? backgroundColor;
  final List<AppBorderSide>? borderSides;
  final Color? borderColor;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.tertiary,
          border: Border(
              top: _getBorderSide(AppBorderSide.top),
              bottom: _getBorderSide(AppBorderSide.bottom),
              left: _getBorderSide(AppBorderSide.left),
              right: _getBorderSide(AppBorderSide.right))),
      child: child,
    );
  }

  BorderSide _getBorderSide(AppBorderSide side) {
    final unWrappedSides =
        borderSides ?? [AppBorderSide.top, AppBorderSide.bottom];
    return unWrappedSides.contains(side)
        ? BorderSide(
            color: borderColor ?? AppColors.color717171,
            width: borderWidth ?? 0.5)
        : BorderSide.none;
  }
}

enum AppBorderSide {
  top,
  left,
  right,
  bottom;
}
