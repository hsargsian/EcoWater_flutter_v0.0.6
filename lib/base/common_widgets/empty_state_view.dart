import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'tag_view.dart';

@immutable
class EmptyStateView extends StatelessWidget {
  const EmptyStateView(
      {required this.tags,
      this.imageString,
      this.title,
      this.detailText,
      super.key});
  final String? imageString;
  final String? title;
  final String? detailText;
  final List<TagView> tags;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      imageString == null
          ? const SizedBox.shrink()
          : FractionallySizedBox(
              widthFactor: 0.5,
              child: imageString!.contains('svg')
                  ? SvgPicture.asset(
                      imageString!,
                      height: 250,
                    )
                  : Image(image: AssetImage(imageString!))),
      Visibility(
        visible: title != null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            (title ?? '').localized,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryElementColor),
          ),
        ),
      ),
      Visibility(
        visible: detailText != null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text((detailText ?? '').localized,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primaryElementColor)),
        ),
      ),
      Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: tags,
        ),
      )
    ]);
  }
}
