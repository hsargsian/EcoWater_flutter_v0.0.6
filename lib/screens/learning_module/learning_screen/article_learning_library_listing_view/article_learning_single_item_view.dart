import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../../base/utils/images.dart';
import '../../../../core/domain/domain_models/article_learning_library_domain.dart';

class ArticleLearningSingleItemView extends StatelessWidget {
  const ArticleLearningSingleItemView({required this.item, this.onSeeAllClick, super.key});
  final ArticleLearningLibraryDomain item;
  final Function()? onSeeAllClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                    children: [SvgPicture.asset(Images.arrowCircleRight), Text('ArticleLibrary_seeAll'.localized)],
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: AppImageView(
                                height: constraints.maxHeight,
                                cornerRadius: 0,
                                placeholderImage: Images.imagePlaceholderPng,
                                width: double.maxFinite,
                                placeholderHeight: constraints.maxHeight,
                                placeholderWidth: double.maxFinite,
                                placeholderFit: BoxFit.fitWidth,
                                avatarUrl: item.thumbnail),
                          ),
                          Positioned(
                              bottom: 7,
                              left: 5,
                              right: 5,
                              child: Text(item.title,
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400))),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
