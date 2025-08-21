import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/flask_module/search_and_pair_screen/search_and_pair_screen.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_item_view.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';

class SearchAndPairOnboardingScreen extends StatefulWidget {
  const SearchAndPairOnboardingScreen({super.key});

  @override
  State<SearchAndPairOnboardingScreen> createState() =>
      _SearchAndPairOnboardingScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/SearchAndPairOnboardingScreen'),
        builder: (_) => const SearchAndPairOnboardingScreen());
  }
}

class _SearchAndPairOnboardingScreenState
    extends State<SearchAndPairOnboardingScreen> {
  var _currentPage = 0;
  late PageController _pageController;
  var _items = <OnboardingModel>[];

  @override
  void initState() {
    _items = OnboardingModel.getDeviceConnectionOnboardingModel();
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
      _checkBLEPermissionAndNavigateToSearchAndPair();
    }
  }

  Future<void> _checkBLEPermissionAndNavigateToSearchAndPair() async {
    final bleCheckResponse =
        await Utilities.checkBLEState(showsAlert: true, context: context);
    if (!bleCheckResponse.first) {
      if (bleCheckResponse.second != null) {
        if (!mounted) {
          return;
        }
        Utilities.showSnackBar(
            context, bleCheckResponse.second!, SnackbarStyle.error);
      }
      return;
    }
    if (!mounted) {
      return;
    }
    await Navigator.push(
        context, SearchAndPairScreen.route(isFromDeviceListing: false));
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
                return OnBoardingItemView(item: _items[index]);
              }),
          Positioned(
              top: 50,
              right: 20,
              child: Visibility(
                visible: _items[_currentPage].showsSkipButton,
                child: InkWell(
                  onTap: () {
                    Injector.instance<AuthenticationBloc>()
                        .add(AuthenticationCheckUserSessionEvent());

                    // Navigator.push(context,
                    //     SearchAndPairScreen.route(isFromDeviceListing: false));
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
                  Navigator.pop(context);
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
