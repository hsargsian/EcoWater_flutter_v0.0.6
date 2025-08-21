import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconTitleWidget extends StatelessWidget {
  const IconTitleWidget(
      {required this.icon,
      required this.title,
      Color? titleColor,
      double fontSize = 13,
      double padding = 5,
      super.key})
      : _titleColor = titleColor,
        _fontSize = fontSize,
        _padding = padding;
  final Widget icon;
  final String title;
  final Color? _titleColor;
  final double _fontSize;
  final double _padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: _padding,
        ),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.quicksand(
                fontSize: _fontSize,
                fontWeight: FontWeight.w600,
                color: _titleColor ??
                    Theme.of(context).colorScheme.primaryElementColor),
          ),
        )
      ],
    );
  }
}
