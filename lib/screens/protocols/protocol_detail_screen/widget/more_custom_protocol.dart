import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../base/common_widgets/alert/alert.dart';
import '../../../../base/constants/string_constants.dart';
import '../../../../base/utils/images.dart';

class MoreCustomProtocol extends StatelessWidget {
  const MoreCustomProtocol({this.editCustomProtocolTaped, this.deleteCustomProtocolTaped, super.key});

  final Function? editCustomProtocolTaped;
  final Function? deleteCustomProtocolTaped;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            color: Theme.of(context).colorScheme.secondaryElementColor,
            height: 2,
            width: 50,
          ),
          Text('Custom Protocol',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: StringConstants.fieldGothicTestFont)),
          _drawHorizontalLine,
          GestureDetector(
            onTap: () {
              editCustomProtocolTaped?.call();
            },
            child: Row(
              spacing: 12,
              children: [
                const SizedBox.shrink(),
                SvgPicture.asset(
                  Images.editIconSVG,
                  height: 17,
                ),
                Text(
                  'Edit Custom Protocol',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 17),
                ),
              ],
            ),
          ),
          _drawHorizontalLine,
          GestureDetector(
            onTap: () {
              Navigator.pop(context);

              _deleteCustomProtocolAlert(context);
            },
            child: Row(
              spacing: 12,
              children: [
                const SizedBox.shrink(),
                SvgPicture.asset(Images.deleteIconSVG),
                Text(
                  'Delete Custom Protocol',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 17),
                ),
              ],
            ),
          ),
          _drawHorizontalLine,
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  void _deleteCustomProtocolAlert(BuildContext context) {
    final alert = Alert();
    alert.showAlert(
        context: context,
        isWarningAlert: true,
        message: 'Are you sure you want to delete this custom protocol.',
        actionWidget: alert.getDefaultTwoButtons(
            firstButtonTitle: 'No',
            lastButtonTitle: 'Yes',
            onFirstButtonClick: () {
              Navigator.pop(context);
            },
            onLastButtonClick: () {
              deleteCustomProtocolTaped?.call();
            },
            context: context,
            isAlternate: true));
  }

  Widget get _drawHorizontalLine {
    return const Divider(
      thickness: 1,
      color: AppColors.tertiaryBackgroundColorDark,
    );
  }
}
