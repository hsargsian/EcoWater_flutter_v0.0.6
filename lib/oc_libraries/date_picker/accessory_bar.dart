import 'package:flutter/material.dart';

class DatePickerAccessoryBar extends StatelessWidget {
  const DatePickerAccessoryBar(
      {this.title,
      this.doneText,
      this.cancelTitle = 'Cancel',
      this.cancelTextStyle,
      this.onCancelPressed,
      this.onDonePressed,
      this.doneTextStyle,
      this.titleTextStyle,
      this.canPressDone = true,
      this.backgroundColor,
      super.key});
  final String? cancelTitle;
  final String? title;
  final TextStyle? cancelTextStyle;
  final TextStyle? doneTextStyle;
  final TextStyle? titleTextStyle;
  final String? doneText;
  final Color? backgroundColor;
  final Function()? onCancelPressed;
  final Function()? onDonePressed;
  final bool canPressDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onCancelPressed,
              child: SizedBox(
                width: 70,
                child: Center(
                    child: Text(cancelTitle ?? 'Cancel',
                        style: cancelTextStyle ??
                            TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))),
              ),
            ),
            Text(
              title ?? '',
              style: titleTextStyle ??
                  TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: canPressDone ? onDonePressed : null,
              child: SizedBox(
                width: 70,
                child: Visibility(
                  visible: doneText != null,
                  child: Center(
                    child: Text(doneText ?? 'Done',
                        style: doneTextStyle ??
                            TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
