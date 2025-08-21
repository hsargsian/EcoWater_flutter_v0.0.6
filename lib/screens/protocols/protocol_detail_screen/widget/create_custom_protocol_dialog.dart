import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../../base/common_widgets/buttons/app_button.dart';
import '../../../../base/constants/string_constants.dart';
import '../../../../base/utils/colors.dart';

class CreateCustomProtocolDialog extends StatelessWidget {
  const CreateCustomProtocolDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 4,
            ),
            Container(
              color: Theme.of(context).colorScheme.secondaryElementColor,
              height: 3,
              width: 50,
            ),
            const SizedBox(
              height: 4,
            ),
            Text('Create Custom Protocol ?',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontFamily: StringConstants.fieldGothicFont, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 12,
            ),
            Text('How would you like to create this ?',
                textAlign: TextAlign.center,
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondaryElementColor)),
            const SizedBox(
              height: 20,
            ),
            AppButton(
                title: 'Create with my Health App data', height: 45, radius: 22.5, hasGradientBackground: true, onClick: () {}),
            const SizedBox(
              height: 4,
            ),
            AppButton(title: 'Take the H2 Quiz', height: 45, radius: 22.5, hasGradientBackground: true, onClick: () {}),
            const SizedBox(
              height: 4,
            ),
            AppButton(title: 'Customize Myself', height: 45, radius: 22.5, hasGradientBackground: true, onClick: () {}),
            const SizedBox(
              height: 4,
            ),
            AppButton(
                title: 'Cancel',
                height: 45,
                radius: 22.5,
                elevation: 0,
                backgroundColor: AppColors.black,
                border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
                onClick: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
    ;
  }
}
