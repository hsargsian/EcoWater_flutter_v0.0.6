import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../core/domain/domain_models/friend_request_wrapper_domain.dart';
import '../common_widgets/overlapping_stack_view/overlapping_stacked_image_configuration.dart';
import '../common_widgets/overlapping_stack_view/overlapping_stacked_image_view.dart';

class FriendRequestsNotificationView extends StatelessWidget {
  const FriendRequestsNotificationView(
      {required this.requestsWrapper, super.key});
  final FriendRequestsWrapperDomain requestsWrapper;

  @override
  Widget build(BuildContext context) {
    return requestsWrapper.requests.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AppBoxedContainer(
                borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      OverlappingStackedImageView(
                        items: requestsWrapper.overlappingNotificationImages,
                        configuration: OverlappingStackedImageConfiguration(
                            maxImagesToShow: 3,
                            itemSize: 40,
                            itemBorderWidth: 1,
                            offsetPercentage: 0.4,
                            showsMoreCountLabel: false,
                            borderColor: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withValues(alpha: 0.5)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Friend_Requests_Title'.localized),
                              Text(requestsWrapper.notificationRequestsTitle())
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
  }
}
