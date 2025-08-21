import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../base/app_specific_widgets/gradient_text.dart';
import '../../../base/app_specific_widgets/gradient_text_app_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../core/domain/domain_models/friend_request_domain.dart';

class FriendRequest extends StatelessWidget {
  const FriendRequest(this.request, {this.acceptRequest, this.declineRequest, super.key});

  final FriendRequestDomain request;
  final Function(FriendRequestDomain model)? acceptRequest;
  final Function(FriendRequestDomain model)? declineRequest;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppImageView(
          avatarUrl: request.profileImage,
          width: 50,
          height: 50,
          cornerRadius: 60,
          placeholderHeight: 74,
          placeholderWidth: 74,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: RichText(
                        text: TextSpan(
                            text: request.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: 'FriendRequestScreen_requestedFollow'.localized,
                              style: Theme.of(context).textTheme.bodyMedium)
                        ])),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GradientTextAppButton(
                      width: 90,
                      height: 30,
                      hasGradientBorder: true,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      child: GradientText(
                        'FriendRequestScreen_ignoreButton'.localized,
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(3, 162, 177, 0.95),
                          Color.fromRGBO(99, 162, 178, 1),
                          Color.fromRGBO(195, 162, 179, 0.93),
                        ]),
                      ),
                      onClick: () {
                        declineRequest?.call(request);
                      }),
                  const SizedBox(
                    width: 8,
                  ),
                  AppButton(
                      title: 'FriendRequestScreen_acceptButton'.localized,
                      hasGradientBackground: true,
                      height: 30,
                      width: 90,
                      onClick: () {
                        acceptRequest?.call(request);
                      }),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
