import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import 'walk_through_manager.dart';
import 'walk_through_screen_item.dart';

class WalkThroughInfoView extends StatelessWidget {
  const WalkThroughInfoView(
      {required this.screenItem, this.profile, super.key});
  final UserDomain? profile;
  final WalkThroughScreenItem screenItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.highLightColor,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    WalkThroughManager()
                        .currentWalkthroughItem
                        .title(profile?.firstName ?? ''),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    WalkThroughManager().currentWalkthroughItem.counter,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      WalkThroughManager().endWalkThrough(screenItem);
                    },
                    child: Text(
                      'skip'.localized,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(WalkThroughManager().currentWalkthroughItem.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 15,
            ),
            WalkThroughManager()
                .currentWalkthroughItem
                .buttonView(context, screenItem)
          ],
        ),
      ),
    );
  }
}
