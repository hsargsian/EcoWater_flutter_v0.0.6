import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/flask_module/clean_flask_screen/bloc/clean_flask_screen_bloc.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../base/app_specific_widgets/animating_pulse_lottie_view.dart';
import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/utils/animations.dart';
import '../../../core/domain/domain_models/flask_domain.dart';
import '../../../core/domain/domain_models/flask_option.dart';
import '../../../oc_libraries/ble_service/ble_manager.dart';
import '../../onboarding_flow/onboarding_item_view.dart';

class CleanFlaskScreen extends StatefulWidget {
  const CleanFlaskScreen({required this.flask, super.key});
  final FlaskDomain flask;

  @override
  State<CleanFlaskScreen> createState() => _CleanFlaskScreenState();

  static Route<void> route({required FlaskDomain flask}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/CleanFlaskScreen'),
        builder: (_) => CleanFlaskScreen(
              flask: flask,
            ));
  }
}

class _CleanFlaskScreenState extends State<CleanFlaskScreen> {
  var _currentPage = 0;
  late PageController _pageController;
  final _items = OnboardingModel.getCleanBottleModel();
  bool _showingAnimator = false;
  String _title = '';

  late final CleanFlaskScreenBloc _bloc;

  @override
  void initState() {
    _bloc = Injector.instance<CleanFlaskScreenBloc>();
    _pageController = PageController();
    super.initState();

    _pageController.addListener(() {
      _currentPage = _pageController.page!.toInt();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(() {})
      ..dispose();
    super.dispose();
  }

  void _onNextPage({bool isToShowAnimator = false}) {
    if ((_currentPage == 1 || _currentPage == 2) && isToShowAnimator) {
      _showingAnimator = true;
      _title = _currentPage == 1
          ? 'CleanFlaskScreen_cleaning'.localized
          : 'CleanFlaskScreen_rinsing'.localized;
      if (mounted) {
        setState(() {});
      }
      Future.delayed(
          const Duration(seconds: Constants.flaskCleanDuration), _onNextPage);
    } else {
      _currentPage += 1;
      _showingAnimator = false;
      if (mounted) {
        setState(() {});
      }
      _pageController.animateToPage(_currentPage,
          duration: Duration(
              milliseconds: (_currentPage == 2 || _currentPage == 3) ? 1 : 300),
          curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Visibility(
                      visible: _showingAnimator,
                      child: AnimatingPulseLottieView(
                        path: Animations.blueAnimation,
                        text: _title,
                      )),
                ),
                PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return _showingAnimator
                          ? const SizedBox.shrink()
                          : OnBoardingItemView(item: _items[index]);
                    }),
                Visibility(
                  visible: _items[_currentPage].showsBackButton,
                  child: const Positioned(
                      top: 50, left: 20, child: LeftArrowBackButton()),
                )
              ],
            ),
          ),
          Visibility(
            visible: !_showingAnimator,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<CleanFlaskScreenBloc, CleanFlaskScreenState>(
                  bloc: _bloc,
                  listener: (context, state) {
                    _onStateChanged(state, context);
                  },
                  builder: (context, state) {
                    return AppButton(
                      title: _items[_currentPage].buttonTitle,
                      onClick: () {
                        if (_currentPage == 1 || _currentPage == 2) {
                          BleManager().sendData(
                              widget.flask,
                              FlaskCommand.cleanFlask,
                              FlaskCommand.cleanFlask.commandData.addingCRC());
                        } else if (_currentPage == 3) {
                          _bloc.add(AddFlaskCleanLogEvent(flask: widget.flask));
                        }
                        if (_currentPage < 3) {
                          _onNextPage(
                              isToShowAnimator:
                                  _currentPage == 1 || _currentPage == 2);
                        }
                      },
                      height: 45,
                      radius: 30,
                      hasGradientBackground: true,
                      width: MediaQuery.of(context).size.width * 0.9,
                    );
                  },
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
            ),
          )
        ],
      ),
    );
  }

  void _onStateChanged(CleanFlaskScreenState state, BuildContext context) {
    if (state is CleanFlaskScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is UpdatedCleanFlaskLogState) {
      _bloc.add(AddFlaskCleanLogEvent(flask: widget.flask));
      Navigator.pop(context);
    }
  }
}
