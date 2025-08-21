import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../common_widgets/buttons/app_button.dart';

class AppBottomActionsheetView extends StatelessWidget {
  const AppBottomActionsheetView({
    required this.title,
    required this.message,
    required this.posiitiveButtonTitle,
    required this.negativeButtonTitle,
    this.onPositiveButtonClick,
    this.onNegativeButtonClick,
    super.key,
  });
  final Function()? onPositiveButtonClick;
  final Function()? onNegativeButtonClick;
  final String title;
  final String message;
  final String posiitiveButtonTitle;
  final String negativeButtonTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      color: Colors.white.withValues(alpha: 0.2))
                ]),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Theme.of(context).colorScheme.tertiary,
                  height: 6,
                  width: 50,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                const SizedBox(
                  height: 15,
                ),
                Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor)),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                          height: 45,
                          hasGradientBorder: true,
                          title: negativeButtonTitle,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          onClick: () {
                            onNegativeButtonClick?.call();
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: AppButton(
                          height: 45,
                          hasGradientBackground: true,
                          title: posiitiveButtonTitle,
                          onClick: () {
                            onPositiveButtonClick?.call();
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
