import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_type.dart';
import 'package:echowater/screens/auth/login/login.dart';
import 'package:echowater/screens/auth/signup/signup.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_item_view.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/InitialScreen'),
        builder: (_) => const InitialScreen());
  }
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: OnBoardingItemView(
                item: OnboardingModel(
                    headerWidget: SvgPicture.asset(Images.echoLogo),
                    title: 'InitialScreen_JoinHydrationRevolution'.localized,
                    description: null,
                    image: Images.onboardingInitial,
                    topPadding: 0,
                    bottomPadding: 50,
                    buttonTitle: '',
                    showsSkipButton: false,
                    showsBackButton: true,
                    showsPageIndicator: false,
                    backgroundPercentage: 0.2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                      height: 45,
                      hasGradientBorder: true,
                      title: 'InitialScreen_Sign_Up'.localized,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      onClick: () {
                        Navigator.push(context,
                            SignupScreen.route(userType: UserType.normal));
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppButton(
                      height: 45,
                      hasGradientBackground: true,
                      title: 'InitialScreen_Login'.localized,
                      onClick: () {
                        Navigator.push(context, LoginScreen.route());
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
