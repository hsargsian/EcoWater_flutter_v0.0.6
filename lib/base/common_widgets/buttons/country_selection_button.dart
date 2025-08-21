import 'package:flutter/material.dart';
import '../../utils/colors.dart';

@immutable
class CountrySelectionButton extends StatelessWidget {
  const CountrySelectionButton(
      {required String countryCode,
      required String countryImage,
      required Function? onClick,
      required TextStyle textStyle,
      Color backgroundColor = AppColors.transparent,
      double width = 48,
      double height = 48,
      super.key})
      : _countryCode = countryCode,
        _countryImage = countryImage,
        _backgroundColor = backgroundColor,
        _width = width,
        _height = height,
        _textStyle = textStyle,
        _onClick = onClick;
  final String _countryCode;
  final String _countryImage;
  final Function? _onClick;
  final Color _backgroundColor;
  final double _width;
  final double _height;
  final TextStyle _textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: GestureDetector(
        onTap: () {
          _onClick?.call();
        },
        child: Container(
          color: _backgroundColor,
          alignment: Alignment.center,
          child: Center(
            child: Align(
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _countryImage,
                    style: _textStyle,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _countryCode,
                    style: _textStyle,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1,
                    height: _height * 0.6,
                    color: AppColors.tertiaryElementColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
