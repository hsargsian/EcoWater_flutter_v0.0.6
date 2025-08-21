import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/domain_models/protocol_category.dart';
import '../../utils/colors.dart';

enum SingleProtocolCategoryItemViewType {
  normal,
  horizontalSelectable;

  double get contentPadding {
    switch (this) {
      case SingleProtocolCategoryItemViewType.normal:
        return 0;
      case SingleProtocolCategoryItemViewType.horizontalSelectable:
        return 15;
    }
  }

  BoxDecoration? getBoxDecoration(
      {required bool isSelected, required BuildContext context}) {
    switch (this) {
      case SingleProtocolCategoryItemViewType.normal:
        return null;
      case SingleProtocolCategoryItemViewType.horizontalSelectable:
        return BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? Theme.of(context).primaryColor
                : AppColors.transparent,
            border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.onTertiary,
                width: 2));
    }
  }

  TextStyle getTitleTextStyle(
      {required BuildContext context, required bool isSelected}) {
    switch (this) {
      case SingleProtocolCategoryItemViewType.normal:
        return Theme.of(context).textTheme.titleSmall ?? const TextStyle();
      case SingleProtocolCategoryItemViewType.horizontalSelectable:
        return isSelected
            ? Theme.of(context).textTheme.titleSmall ?? const TextStyle()
            : Theme.of(context).textTheme.titleSmall ?? const TextStyle();
    }
  }
}

class SingleLearningCategoryItemView extends StatelessWidget {
  const SingleLearningCategoryItemView(
      {required this.category,
      required this.isSelected,
      required this.type,
      super.key});
  final ProtocolCategoryDomain category;
  final bool isSelected;
  final SingleProtocolCategoryItemViewType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 160,
          height: 30,
          child: Stack(
            children: [
              Visibility(
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(stops: [
                    0.2,
                    0.4,
                    0.8
                  ], colors: [
                    Color.fromRGBO(3, 162, 177, 0.95),
                    Color.fromRGBO(99, 162, 178, 1),
                    Color.fromRGBO(195, 162, 179, 0.93),
                  ])),
                ),
              ),
              Visibility(
                child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: category.isSelected
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(3, 162, 177, 0.95),
                              Color.fromRGBO(99, 162, 178, 1),
                              Color.fromRGBO(195, 162, 179, 0.93)
                            ]))
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).scaffoldBackgroundColor)),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.listTitle.localized,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
