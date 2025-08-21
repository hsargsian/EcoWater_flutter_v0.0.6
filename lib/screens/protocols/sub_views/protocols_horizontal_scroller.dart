import 'package:echowater/screens/protocols/sub_views/protocol_single_item_view.dart';
import 'package:echowater/screens/protocols/sub_views/protocols_listing_view/bloc/protocols_listing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base/utils/colors.dart';
import '../../../core/domain/domain_models/protocols_wrapper_domain.dart';

class ProtocolsHorizontalScroller extends StatelessWidget {
  ProtocolsHorizontalScroller(
      {required this.protocolWrapper,
      required this.title,
      required this.showsShowAll,
      required this.scrollDirection,
      required this.bloc,
      required this.onRefreshedPage,
      this.bottomView,
      super.key});

  ProtocolsWrapperDomain protocolWrapper;
  Widget? bottomView;
  final String title;
  final bool showsShowAll;
  final Axis scrollDirection;
  final ProtocolsListingBloc bloc;
  final VoidCallback onRefreshedPage;

  Widget _placeholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 25, left: 20, right: 20),
      child: Shimmer.fromColors(
        baseColor: AppColors.color717171Base,
        highlightColor: AppColors.color717171Base.withValues(alpha: 0.8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                height: 30,
                width: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final protocols = protocolWrapper.protocols;
    return protocolWrapper.hasFetched
        ? Column(
            children: [
              if (scrollDirection == Axis.horizontal)
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SingleProtocolItemView(
                        protocol: protocols[index],
                        protocolType: title,
                        isFullWidth: false,
                        bloc: bloc,
                        onRefreshedPage: onRefreshedPage,
                      );
                    },
                    itemCount: protocols.length,
                  ),
                )
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SingleProtocolItemView(
                        protocol: protocols[index],
                        protocolType: title,
                        isFullWidth: true,
                        bloc: bloc,
                        onRefreshedPage: onRefreshedPage);
                  },
                  itemCount: protocols.length,
                ),
              if (bottomView != null) bottomView!
            ],
          )
        : _placeholder(context);
  }
}
