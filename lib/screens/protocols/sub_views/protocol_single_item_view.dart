import 'package:echowater/base/utils/images.dart';
import 'package:echowater/core/domain/domain_models/protocols_wrapper_domain.dart';
import 'package:echowater/screens/protocols/protocol_detail_screen/protocol_detail_screen.dart';
import 'package:echowater/screens/protocols/sub_views/protocols_listing_view/bloc/protocols_listing_bloc.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../base/common_widgets/protocol_active_button.dart';
import '../../../base/utils/utilities.dart';

class SingleProtocolItemView extends StatelessWidget {
  const SingleProtocolItemView(
      {required this.protocol,
      required this.bloc,
      required this.protocolType,
      required this.isFullWidth,
      required this.onRefreshedPage,
      super.key});

  final ProtocolDomain protocol;
  final bool isFullWidth;
  final String protocolType;
  final ProtocolsListingBloc bloc;
  final VoidCallback onRefreshedPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utilities.showBottomSheet(
            widget: ProtocolDetailScreen(
              protocol: protocol,
              protocolType: protocolType,
              bloc: bloc,
              onRefreshedPage: onRefreshedPage,
            ),
            context: context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width * (isFullWidth ? 1.0 : 0.8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            protocol.image.contains(Images.defaultProtocolImage)
                ? Image.asset(
                    Images.defaultProtocolImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fitWidth,
                  )
                : AppImageView(
                    width: double.infinity,
                    height: double.infinity,
                    placeholderWidth: double.infinity,
                    placeholderHeight: double.infinity,
                    cornerRadius: 10,
                    avatarUrl: protocol.image,
                  ),
            Positioned.fill(
                child: Container(
              color: Colors.black54,
            )),
            Positioned(
                top: 10,
                right: 10,
                child: ProtocolActiveButton(
                  isActive: protocol.isActive,
                  onPressed: () {},
                )),
            Positioned(
                left: 10,
                bottom: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      protocol.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      protocol.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.primaryElementColor),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
