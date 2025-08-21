import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingItemView extends StatelessWidget {
  const OnBoardingItemView({required this.item, super.key});
  final OnboardingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: item.topPadding),
      decoration: item.image == null
          ? null
          : BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: AssetImage(item.image!))),
      child: Stack(
        children: [
          Visibility(
            visible: item.hasGradientBackground ?? true,
            child: Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                height: item.backgroundPercentage == null
                    ? 400
                    : (item.backgroundPercentage! *
                        MediaQuery.of(context).size.height),
                child: SvgPicture.asset(Images.onboardingGradientBackground,
                    fit: BoxFit.cover, alignment: Alignment.topCenter)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    if (item.headerWidget != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: item.headerWidget!,
                      ),
                    Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 40,
                              fontFamily: StringConstants.fieldGothicFont,
                              fontWeight: FontWeight.w500),
                    ),
                    Visibility(
                      visible: item.description != null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          item.description ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: item.bottomPadding,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
