import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../../base/common_widgets/buttons/app_button.dart';
import '../../../../base/constants/string_constants.dart';

class UpdateProtocolGoalDialog extends StatelessWidget {
  const UpdateProtocolGoalDialog({required this.clickedUpdate, super.key});

  final Function(bool isUpdate) clickedUpdate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Theme.of(context).colorScheme.secondaryElementColor,
                height: 3,
                width: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Update Goals Based on Protocol ?',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontFamily: StringConstants.fieldGothicFont, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 12,
              ),
              Text('This protocol has recommended goals for H2, Water and Flasks consumption. Would you like to update them?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.secondaryElementColor)),
              const SizedBox(
                height: 12,
              ),
              AppButton(
                  title: 'Yes, Update My Goals',
                  height: 45,
                  radius: 22.5,
                  hasGradientBackground: true,
                  onClick: () {
                    clickedUpdate(true);
                    Navigator.pop(context);
                  }),
              const SizedBox(
                height: 12,
              ),
              AppButton(
                  title: 'No, Keep My Goals',
                  height: 45,
                  radius: 22.5,
                  elevation: 0,
                  backgroundColor: AppColors.black,
                  border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
                  onClick: () {
                    clickedUpdate(false);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
