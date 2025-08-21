import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_item_view.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../flask_module/search_and_pair_screen/search_and_pair_onboarding_screen.dart';

class OnboardingAppIntroScreen extends StatefulWidget {
  const OnboardingAppIntroScreen({required this.isFromProfile, super.key});
  final bool isFromProfile;

  @override
  State<OnboardingAppIntroScreen> createState() =>
      _OnboardingAppIntroScreenState();

  static Route<void> route({required bool isFromProfile}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/OnboardingScreen'),
        builder: (_) => OnboardingAppIntroScreen(
              isFromProfile: isFromProfile,
            ));
  }
}

class _OnboardingAppIntroScreenState extends State<OnboardingAppIntroScreen> {
  var _currentPage = 0;
  late PageController _pageController;
  var _items = <OnboardingModel>[];

  @override
  void initState() {
    _items =
        OnboardingModel.getOnboardingModel(isFromProfile: widget.isFromProfile);
    _pageController = PageController();
    super.initState();

    _pageController.addListener(() {
      _currentPage = _pageController.page!.toInt();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(() {})
      ..dispose();
    super.dispose();
  }

  void _onChangePage({required int increment}) {
    if (increment < 0) {
      _currentPage -= 1;
      setState(() {});
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else if (_currentPage < _items.length - 1) {
      _currentPage += increment;
      setState(() {});
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      if (widget.isFromProfile) {
        Navigator.pop(context);
        return;
      }
      Navigator.push(context, SearchAndPairOnboardingScreen.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
              itemCount: _items.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                if (index == _items.length - 1) {
                  return Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: Lottie.asset('assets/lottie/echo_check.json',
                            repeat: false),
                      ),
                      OnBoardingItemView(item: _items[index])
                    ],
                  );
                }
                return OnBoardingItemView(item: _items[index]);
              }),
          Positioned(
              top: 50,
              right: 20,
              child: Visibility(
                visible: _items[_currentPage].showsSkipButton,
                child: InkWell(
                  onTap: () {
                    if (widget.isFromProfile) {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.push(
                        context, SearchAndPairOnboardingScreen.route());
                  },
                  child: Text('skip'.localized,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary)),
                ),
              )),
          Visibility(
            visible: _items[_currentPage].showsBackButton,
            child: Positioned(
                top: 50,
                left: 20,
                child: LeftArrowBackButton(onButtonPressed: () {
                  if (widget.isFromProfile) {
                    Navigator.pop(context);
                    return;
                  }
                  _onChangePage(increment: -1);
                })),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                  alignment: Alignment.bottomCenter, child: _bottomView()))
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        AppButton(
          title: _items[_currentPage].buttonTitle,
          onClick: () {
            _onChangePage(increment: 1);
          },
          height: 45,
          radius: 30,
          hasGradientBackground: true,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: _items[_currentPage].showsPageIndicator,
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _items.length,
            effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
