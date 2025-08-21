import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

class OnboardingModel {
  OnboardingModel(
      {required this.title,
      required this.description,
      required this.image,
      required this.topPadding,
      required this.bottomPadding,
      required this.buttonTitle,
      required this.showsBackButton,
      required this.showsSkipButton,
      required this.showsPageIndicator,
      this.headerWidget,
      this.hasGradientBackground,
      this.backgroundPercentage});

  final String title;
  final String? description;
  final String? image;
  final double topPadding;
  final double bottomPadding;
  final String buttonTitle;
  final bool showsBackButton;
  final bool showsSkipButton;
  final bool showsPageIndicator;
  final Widget? headerWidget;
  final bool? hasGradientBackground;
  final double? backgroundPercentage;

  static List<OnboardingModel> getOnboardingModel(
      {required bool isFromProfile}) {
    return [
      OnboardingModel(
          title: 'Onboarding1_title'.localized,
          description: 'Onboarding1_description'.localized,
          image: Images.onboarding_1,
          topPadding: 0,
          bottomPadding: 180,
          showsBackButton: isFromProfile,
          showsSkipButton: !isFromProfile,
          buttonTitle: 'Next'.localized,
          showsPageIndicator: true,
          hasGradientBackground: false),
      OnboardingModel(
        title: 'Onboarding2_title'.localized,
        description: 'Onboarding2_description'.localized,
        image: Images.onboarding_2,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: 'Next'.localized,
        showsPageIndicator: true,
      ),
      OnboardingModel(
        title: 'Onboarding3_title'.localized,
        description: 'Onboarding3_description'.localized,
        image: Images.onboarding_3,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: 'Next'.localized,
        showsPageIndicator: true,
      ),
      OnboardingModel(
        title: 'Onboarding4_title'.localized,
        description: 'Onboarding4_description'.localized,
        image: Images.onboarding_4,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: 'Next'.localized,
        showsPageIndicator: true,
      ),
      OnboardingModel(
        title: 'Onboarding5_title'.localized,
        description: 'Onboarding5_description'.localized,
        image: Images.onboarding_5,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: 'Next'.localized,
        showsPageIndicator: true,
      ),
      OnboardingModel(
        title: 'Onboarding6_title'.localized,
        description: 'Onboarding6_description'.localized,
        image: Images.onboarding_6,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: 'Next'.localized,
        showsPageIndicator: true,
      ),
      OnboardingModel(
        title: 'Onboarding7_title'.localized,
        description: 'Onboarding7_description'.localized,
        image: null,
        topPadding: 80,
        bottomPadding: 180,
        showsBackButton: isFromProfile,
        showsSkipButton: !isFromProfile,
        buttonTitle: isFromProfile ? 'Done'.localized : 'Next'.localized,
        showsPageIndicator: true,
      ),
    ];
  }

  static List<OnboardingModel> getDeviceConnectionOnboardingModel() {
    return [
      OnboardingModel(
          title: 'Device_Onboarding1_title'.localized,
          description: 'Device_Onboarding1_description'.localized,
          image: Images.deviceOnboarding_1,
          topPadding: 0,
          bottomPadding: 180,
          showsBackButton: true,
          backgroundPercentage: 0.4,
          showsSkipButton: false,
          buttonTitle: 'Begin Pairing'.localized,
          showsPageIndicator: false),
    ];
  }

  static List<OnboardingModel> getCleanBottleModel() {
    return [
      OnboardingModel(
          title: 'Onboarding_clean_bottle1_title'.localized,
          description: 'Onboarding_clean_bottle1_description'.localized,
          image: Images.cleanFlaskStep1,
          topPadding: 0,
          bottomPadding: 20,
          showsBackButton: true,
          showsSkipButton: false,
          buttonTitle: 'Next'.localized,
          showsPageIndicator: true,
          backgroundPercentage: 0.25,
          headerWidget: Text('Onboarding_clean_bottle_step_1'.localized)),
      OnboardingModel(
          title: 'Onboarding_clean_bottle2_title'.localized,
          description: 'Onboarding_clean_bottle2_description'.localized,
          image: Images.cleanFlaskStep2,
          topPadding: 0,
          bottomPadding: 20,
          backgroundPercentage: 0.25,
          showsBackButton: true,
          showsSkipButton: false,
          buttonTitle: 'Start'.localized,
          showsPageIndicator: true,
          headerWidget: Text('Onboarding_clean_bottle_step_2'.localized)),
      OnboardingModel(
          title: 'Onboarding_clean_bottle3_title'.localized,
          description: 'Onboarding_clean_bottle3_description'.localized,
          image: Images.cleanFlaskOnboarding,
          topPadding: 50,
          bottomPadding: 50,
          backgroundPercentage: 0.3,
          showsBackButton: true,
          showsSkipButton: false,
          buttonTitle: 'Start'.localized,
          showsPageIndicator: true,
          headerWidget: Text('Onboarding_clean_bottle_step_3'.localized)),
      OnboardingModel(
          title: 'Onboarding_clean_bottle4_title'.localized,
          description: 'Onboarding_clean_bottle4_description'.localized,
          image: Images.cleanFlaskOnboarding,
          topPadding: 50,
          bottomPadding: 50,
          backgroundPercentage: 0.3,
          showsBackButton: true,
          showsSkipButton: false,
          buttonTitle: 'complete'.localized,
          showsPageIndicator: true,
          headerWidget: Text('Onboarding_clean_bottle_step_4'.localized)),
    ];
  }
}
