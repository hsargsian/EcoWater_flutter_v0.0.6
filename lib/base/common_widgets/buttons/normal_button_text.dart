import 'package:flutter/material.dart';

class NormalTextButton extends StatelessWidget {
  const NormalTextButton(
      {required this.title,
      this.textColor,
      this.onClick,
      this.isEnabled = true,
      this.fontSize,
      this.textStyle,
      super.key});
  final String title;
  final Function()? onClick;
  final Color? textColor;
  final bool isEnabled;
  final double? fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
                color: textColor ?? Theme.of(context).primaryColor,
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.normal),
      ),
    );
  }
}
