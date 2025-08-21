import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../../base/utils/colors.dart';

class ReportProfileScreen extends StatelessWidget {
  const ReportProfileScreen({required this.name, this.onReportProfile, super.key});

  final String name;
  final Function()? onReportProfile;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondary,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
        child: Column(
          children: [
            SizedBox(
              width: 50,
              child: Divider(thickness: 2, color: AppColors.color717171),
            ),
            const SizedBox(
              height: 12,
            ),
            const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(
              height: 12,
            ),
            RichText(
                text: TextSpan(
                    text: 'ReortprofileScreen_weWontTell'.localized,
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                  TextSpan(text: ' $name', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'ReortprofileScreen_whoReportedText'.localized, style: Theme.of(context).textTheme.bodyLarge)
                ])),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    border: const BorderSide(color: Colors.white),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    width: 150,
                    title: 'Cancel'.localized,
                    onClick: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(
                  width: 24,
                ),
                AppButton(
                    hasGradientBackground: true,
                    width: 150,
                    title: 'Report'.localized,
                    onClick: () {
                      Navigator.pop(context);
                      onReportProfile?.call();
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
