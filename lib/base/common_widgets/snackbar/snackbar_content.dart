import 'package:flutter/material.dart';

import '../../common_widgets/snackbar/snackbar_style.dart';
import '../../utils/colors.dart';

class SnackBarContent extends StatelessWidget {
  const SnackBarContent(
      {required this.message,
      required this.style,
      this.dynamicContent,
      this.dynamicBackgroundColor,
      super.key});
  final String message;
  final SnackbarStyle style;
  final Widget? dynamicContent;
  final Color? dynamicBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color:
              dynamicBackgroundColor ?? style.displayBackgroundColor(context),
          borderRadius: BorderRadius.circular(15)),
      child: dynamicContent ??
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 17, bottom: 17),
                  child: Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: style.displayTitleColor),
                  ),
                ),
              ),
              Visibility(
                visible: style != SnackbarStyle.validationError,
                child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.transparent,
                    )),
              )
            ],
          ),
    );
  }
}
