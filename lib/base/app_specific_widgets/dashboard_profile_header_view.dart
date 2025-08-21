import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/domain/domain_models/flask_domain.dart';

class DashboardProfileHeaderView extends StatelessWidget {
  const DashboardProfileHeaderView(this.profileInformation,
      {required this.flasks, super.key});

  final UserDomain? profileInformation;
  final List<FlaskDomain> flasks;

  Widget _placeholder(BuildContext context) {
    return Stack(
      children: [
        AppBoxedContainer(
          borderSides: const [AppBorderSide.bottom],
          child: Shimmer.fromColors(
            baseColor: AppColors.color717171Base,
            highlightColor: AppColors.color717171Base.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 20, right: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      height: 60,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return profileInformation == null
        ? _placeholder(context)
        : AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 10),
            child: AppBoxedContainer(
              borderSides: const [AppBorderSide.bottom],
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 25, left: 15, right: 15),
                child: Row(
                  children: [
                    AppImageView(
                      height: 43,
                      width: 43,
                      placeholderHeight: 43,
                      placeholderWidth: 43,
                      avatarUrl: profileInformation?.primaryImageUrl(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _profileInfoView(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                                profileInformation!.fueledByText(flasks),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _profileInfoView() {
    if (profileInformation == null) {
      return const Loader();
    }
    return Row(
      children: [
        Expanded(
          child: Builder(builder: (context) {
            final name = '${"Hello".localized},'
                ' ${profileInformation!.capitalizedFirstname}';
            return Text(
              name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontStyle: FontStyle.normal,
                    fontFamily: StringConstants.fieldGothicFont,
                  ),
            );
          }),
        ),
      ],
    );
  }
}
