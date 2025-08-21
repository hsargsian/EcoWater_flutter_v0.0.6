import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
import '../../utils/utilities.dart';
import '../buttons/app_button.dart';

class Alert {
  void showAlert(
      {required BuildContext context,
      String? message,
      Widget? actionWidget,
      String? title,
      Color? backgroundColor,
      double cornerRadius = 10,
      Color? titleColor,
      TextAlign titleAlign = TextAlign.left,
      Color? messageColor,
      Color barrierColor = Colors.black54,
      bool isWarningAlert = false,
      Widget? tertiaryWidget}) {
    Utilities.vibrate();
    showDialog(
      barrierDismissible: false,
      barrierColor: barrierColor,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Material(
            color: AppColors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).dialogBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryElementColor
                                  .withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  title,
                                  textAlign: titleAlign,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryElementColor),
                                ),
                              )
                            : Container(),
                        if (isWarningAlert)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Warning'.localized,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.appRed),
                            ),
                          ),
                        if (message != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(message,
                                style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryElementColor)),
                          ),
                        if (tertiaryWidget != null) tertiaryWidget,
                        if (actionWidget != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 10),
                            child: actionWidget,
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getDefaultTwoButtons(
      {required BuildContext context,
      required String firstButtonTitle,
      required String lastButtonTitle,
      required Function()? onFirstButtonClick,
      required Function()? onLastButtonClick,
      bool isAlternate = false}) {
    return Row(
      children: [
        Expanded(
            child: AppButton(
          title: firstButtonTitle,
          height: 35,
          onClick: onFirstButtonClick,
          border: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: isAlternate ? 0 : 2),
          backgroundColor: isAlternate ? null : AppColors.transparent,
          textColor: isAlternate
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          elevation: 0,
        )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: AppButton(
          title: lastButtonTitle,
          height: 35,
          border: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: isAlternate ? 2 : 0),
          onClick: onLastButtonClick,
          backgroundColor: isAlternate ? AppColors.transparent : null,
          textColor: isAlternate
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          elevation: 0,
        ))
      ],
    );
  }

  Widget getDefaultSingleButtons(
      {required String buttonTitle, required Function()? onButtonClick}) {
    return Row(
      children: [
        Expanded(child: Container()),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: AppButton(
          title: buttonTitle,
          height: 35,
          onClick: onButtonClick,
          elevation: 0,
        ))
      ],
    );
  }
}
