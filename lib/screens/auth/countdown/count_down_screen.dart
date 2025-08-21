import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/auth/countdown/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/utils/images.dart';
import '../../../core/injector/injector.dart';
import '../../onboarding_flow/onboarding_item_view.dart';
import '../../onboarding_flow/onboarding_model.dart';
import '../authentication/bloc/authentication_bloc.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({required this.targetDate, super.key});

  final DateTime targetDate;

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  late CounterBloc _counterBloc;
  final now = DateTime.now();

  @override
  void initState() {
    _counterBloc = Injector.instance<CounterBloc>();
    calculateTotalSeconds();
    super.initState();
  }

  void calculateTotalSeconds() {
    final totalSeconds = widget.targetDate.difference(now).inSeconds;
    _counterBloc.add(StartCounterEvent(totalSeconds: totalSeconds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnBoardingItemView(
              item: OnboardingModel(
                  title: 'CountDownScreen_thanks'.localized,
                  description: 'CountDownScreen_description'.localized,
                  image: Images.countDownBackground,
                  topPadding: 0,
                  bottomPadding: 150,
                  buttonTitle: '',
                  showsSkipButton: false,
                  showsBackButton: true,
                  showsPageIndicator: false,
                  backgroundPercentage: 0.2)),
          Positioned(left: 0, right: 0, bottom: 10, child: _bottomView()),
          Positioned(
            top: 80,
            child: SvgPicture.asset(
              Images.navBarLogo,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _counterView(),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _counterView() {
    return BlocConsumer<CounterBloc, CounterState>(
      bloc: _counterBloc,
      listener: (context, state) {
        if (state.days == 0 &&
            state.hours == 0 &&
            state.minutes == 0 &&
            state.seconds == 0) {
          Injector.instance<AuthenticationBloc>()
              .add(AuthenticationCheckUserSessionEvent());
        }
      },
      builder: (context, state) {
        if (state.days == 0 &&
            state.hours == 0 &&
            state.minutes == 0 &&
            state.seconds == 0) {
          return const SizedBox.shrink();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _singleItemTime(state.days.toString(), 'Days'),
            _singleItemTime(state.hours.toString(), 'Hrs'),
            _singleItemTime(state.minutes.toString(), 'Min'),
            _singleItemTime(state.seconds.toString(), 'Sec'),
          ],
        );
      },
    );
  }

  Widget _singleItemTime(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }
}
