import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

class AccessoryBar extends StatelessWidget {
  const AccessoryBar(
      {this.title,
      this.doneText,
      this.cancelTitle = 'Cancel',
      this.onCancelPressed,
      this.onDonePressed,
      this.canPressDone = true,
      super.key});
  final String? cancelTitle;
  final String? title;
  final String? doneText;
  final Function()? onCancelPressed;
  final Function()? onDonePressed;
  final bool canPressDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onCancelPressed,
              child: SizedBox(
                width: 100,
                child: Visibility(
                  visible: onCancelPressed != null,
                  child: Center(
                    child: Text(
                      cancelTitle ?? 'Cancel'.localized,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: StringConstants.fieldGothicTestFont),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              title ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: StringConstants.fieldGothicTestFont),
            ),
            GestureDetector(
              onTap: canPressDone ? onDonePressed : null,
              child: SizedBox(
                width: 70,
                child: Visibility(
                  visible: doneText != null,
                  child: Center(
                    child: Text(doneText ?? '',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: StringConstants.fieldGothicTestFont,
                            color: canPressDone
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primaryElementInvertedeColor)),
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
