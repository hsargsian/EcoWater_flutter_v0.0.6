import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/video_learning_library_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../../base/utils/images.dart';

class VideoLearningSingleItemView extends StatelessWidget {
  const VideoLearningSingleItemView({required this.item, this.onSeeAllClick, super.key});
  final VideoLearningLibraryDomain item;
  final Function()? onSeeAllClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (item.isSeeAllView) {
              onSeeAllClick?.call();
            } else {
              Utilities.launchUrl(item.url);
            }
          },
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: item.isSeeAllView
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SvgPicture.asset(Images.arrowCircleRight), Text('VideoLibrary_seeAll'.localized)],
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: AppImageView(
                          avatarUrl: item.thumbnail,
                          height: 300,
                          cornerRadius: 0,
                          width: double.maxFinite,
                          placeholderHeight: 300,
                          placeholderWidth: double.maxFinite,
                          placeholderFit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned.fill(child: SvgPicture.asset(Images.shadowBackground, fit: BoxFit.cover)),
                      Positioned(
                          bottom: 7,
                          left: 5,
                          right: 5,
                          child: Text(item.title,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400))),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
