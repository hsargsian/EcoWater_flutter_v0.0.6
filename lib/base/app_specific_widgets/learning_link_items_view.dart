import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/learning_link_model.dart';
import 'package:echowater/core/domain/domain_models/learning_urls_domain.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../core/services/walkthrough_manager/walk_through_manager.dart';

class LearningLinkItemsView extends StatelessWidget {
  const LearningLinkItemsView({required this.learningUrls, super.key});
  final LearningUrlsDomain learningUrls;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: LearningLinkModel.getItems().map((item) {
          return _singleLearningLinkItemView(context, item);
        }).toList(),
      ),
    );
  }

  Widget _singleLearningLinkItemView(
      BuildContext context, LearningLinkModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: WalkThroughWrapper(
        hasWalkThough: item.type == LearningLinkModelType.support &&
            WalkThroughManager().currentWalkthroughItem ==
                WalkThroughItem.learningSupport,
        clipRadius: WalkThroughManager().currentWalkthroughItem ==
                WalkThroughItem.learningSupport
            ? 10
            : 0,
        child: AppBoxedContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              children: [
                SvgPicture.asset(
                  item.icon,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primaryElementColor,
                      BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(item.title,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w400))),
                InkWell(
                  onTap: () {
                    Utilities.launchUrl(
                        item.type == LearningLinkModelType.digitalManual
                            ? learningUrls.digitalManualUrl
                            : learningUrls.supportUrl);
                  },
                  child: Text(
                    item.buttonTitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
