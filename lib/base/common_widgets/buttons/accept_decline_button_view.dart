import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'app_button.dart';
import 'image_button.dart';

enum AcceptDeclineButtonViewType { imageButton, normalButton }

class AcceptDeclineButtonView extends StatelessWidget {
  const AcceptDeclineButtonView(
      {required this.type,
      this.didClickAcceptButton,
      this.didClickRejectButton,
      super.key});
  final Function? didClickAcceptButton;
  final Function? didClickRejectButton;
  final AcceptDeclineButtonViewType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AcceptDeclineButtonViewType.imageButton:
        return _imageButtons(context);
      case AcceptDeclineButtonViewType.normalButton:
        return _normalButtons(context);
    }
  }

  Widget _normalButtons(BuildContext context) {
    return Row(
      children: [
        AppButton(
          title: 'Confirm'.localized,
          height: 30,
          width: 50,
          radius: 5,
          fontSize: 10,
          onClick: didClickAcceptButton,
        ),
        const SizedBox(
          width: 5,
        ),
        AppButton(
          title: 'Delete'.localized,
          height: 30,
          width: 50,
          radius: 5,
          fontSize: 10,
          backgroundColor: AppColors.transparent,
          textColor: Theme.of(context).colorScheme.primary,
          border: BorderSide(color: Theme.of(context).colorScheme.primary),
          onClick: didClickRejectButton,
        ),
      ],
    );
  }

  Widget _imageButtons(BuildContext context) {
    return Row(
      children: [
        ImageButton(
            icon: Icons.close,
            height: 32,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).colorScheme.error,
            shadowColor: Theme.of(context).colorScheme.error,
            spreadRadius: 1,
            onClick: didClickRejectButton),
        const SizedBox(
          width: 10,
        ),
        ImageButton(
            icon: Icons.check,
            height: 32,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).colorScheme.successColor,
            shadowColor: Theme.of(context).colorScheme.successColor,
            spreadRadius: 1,
            onClick: didClickAcceptButton),
      ],
    );
  }
}
