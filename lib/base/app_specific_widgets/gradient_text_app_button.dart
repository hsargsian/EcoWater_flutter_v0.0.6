import 'package:flutter/material.dart';

import '../common_widgets/buttons/app_button_state.dart';
import '../common_widgets/buttons/decorators/app_button_decorator.dart';
import '../utils/colors.dart';

class GradientTextAppButton extends StatelessWidget {
  const GradientTextAppButton(
      {required Widget child,
      required Function? onClick,
      AppButtonState appButtonState = AppButtonState.enabled,
      Color? backgroundColor,
      Color textColor = AppColors.white,
      double height = 40,
      double radius = 20,
      double elevation = 2,
      double fontSize = 16.0,
      double? width,
      AppButtonDecorator? button,
      BorderSide? border,
      EdgeInsets? padding,
      Widget? icon,
      bool hasUnderline = false,
      bool hasGradientBorder = false,
      bool hasGradientBackground = false,
      super.key})
      : _child = child,
        _appButtonState = appButtonState,
        _backgroundColor = backgroundColor,
        _textColor = textColor,
        _height = height,
        _radius = radius,
        _elevation = elevation,
        _fontSize = fontSize,
        _button = button,
        _onClick = onClick,
        _icon = icon,
        _border = border,
        _padding = padding,
        _hasUnderline = hasUnderline,
        _width = width,
        _hasGradientBorder = hasGradientBorder,
        _hasGradientBackground = hasGradientBackground;
  final Widget _child;
  final AppButtonState _appButtonState;
  final Function? _onClick;
  final Color? _backgroundColor;
  final Color? _textColor;
  final double _height;
  final double? _width;
  final double _radius;
  final double _elevation;
  final double _fontSize;
  final AppButtonDecorator? _button;
  final BorderSide? _border;
  final Widget? _icon;
  final EdgeInsets? _padding;
  final bool _hasUnderline;
  final bool _hasGradientBorder;
  final bool _hasGradientBackground;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: _padding ?? EdgeInsets.zero,
      onPressed:
          _appButtonState == AppButtonState.disabled ? null : _onButtonClick,
      shape: RoundedRectangleBorder(
          side: _border ?? BorderSide.none,
          borderRadius: BorderRadius.circular(_radius)),
      height: _height,
      elevation: _elevation == 0
          ? 0
          : (_appButtonState != AppButtonState.disabled ? 2.0 : _elevation),
      color: (_button?.getBackgroundColor(context, _appButtonState) ??
              _backgroundColor) ??
          Theme.of(context).colorScheme.primary,
      textColor: _button?.getTitleColor(context, _appButtonState) ?? _textColor,
      disabledColor:
          (_button?.getBackgroundColor(context, AppButtonState.disabled) ??
                  _backgroundColor) ??
              Theme.of(context).colorScheme.primary,
      disabledTextColor:
          _button?.getTitleColor(context, AppButtonState.disabled) ??
              _textColor,
      minWidth: _width ?? double.infinity,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      highlightColor:
          (_button?.getBackgroundColor(context, AppButtonState.tapped) ??
                  _backgroundColor) ??
              Theme.of(context).colorScheme.primary,
      enableFeedback: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: SizedBox(
          width: _width ?? double.infinity,
          height: _height,
          child: Stack(
            children: [
              Visibility(
                visible: _hasGradientBorder || _hasGradientBackground,
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(stops: [
                    0.2,
                    0.4,
                    0.8
                  ], colors: [
                    Color.fromRGBO(3, 162, 177, 0.95),
                    Color.fromRGBO(99, 162, 178, 1),
                    Color.fromRGBO(195, 162, 179, 0.93),
                  ])),
                ),
              ),
              Visibility(
                visible: !_hasGradientBackground,
                child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_radius),
                        color: _backgroundColor ??
                            Theme.of(context).colorScheme.primary)),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_icon != null) _icon,
                    if (_icon != null)
                      const SizedBox(
                        width: 4,
                      ),
                    _child,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonClick() {
    _onClick?.call();
  }
}
