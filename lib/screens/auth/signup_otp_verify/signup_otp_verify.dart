import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/auth/login/login.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../base/app_specific_widgets/timer_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/buttons/app_button_state.dart';
import '../../../base/common_widgets/buttons/decorators/primary_button_decorator.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../../../core/services/api_log_service.dart';
import 'bloc/signup_otp_verify_bloc.dart';

class SignupOtpVerifyScreen extends StatefulWidget {
  const SignupOtpVerifyScreen({required this.email, super.key});
  final String email;

  @override
  State<SignupOtpVerifyScreen> createState() => _SignupOtpVerifyScreenState();

  static Route<void> route(String email) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/SignupOtpVerifyScreen'),
        builder: (_) => SignupOtpVerifyScreen(
              email: email,
            ));
  }
}

class _SignupOtpVerifyScreenState extends State<SignupOtpVerifyScreen> {
  final _otpController = TextEditingController();

  bool _isVerifyOtp = false;
  late SignUpOtpVerifyBloc _signUpOtpVerifyBloc;

  @override
  void initState() {
    _signUpOtpVerifyBloc = Injector.instance<SignUpOtpVerifyBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              primary: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        _topView(),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          'SignUp_otp_screen_check_email'.localized,
                          style: GoogleFonts.mulish(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'SignUp_otp_screen_sent_code_message'.localized,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryElementColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _otpView(),
                      ],
                    ),
                    _bottomView(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 60,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)))
        ],
      ),
    );
  }

  Widget _topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 200,
        ),
        Align(
          child: SvgPicture.asset(
            Images.navBarLogo,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        )
      ],
    );
  }

  Widget _otpView() {
    return BlocConsumer<SignUpOtpVerifyBloc, SignUpOtpVerifyState>(
        bloc: _signUpOtpVerifyBloc,
        listener: (context, state) {
          _onStateChanged(state, context);
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: PinCodeTextField(
                appContext: context,
                textCapitalization: TextCapitalization.characters,
                length: 6,
                autoDisposeControllers: false,
                onChanged: (value) {
                  _isVerifyOtp = _otpController.text.length == 6;
                  setState(() {});
                },
                controller: _otpController,
                keyboardType: TextInputType.text,
                pinTheme: PinTheme(
                  activeColor: Theme.of(context).primaryColor,
                  selectedColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                  borderWidth: 1,
                  shape: PinCodeFieldShape.box,
                ),
                textStyle: GoogleFonts.quicksand(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primaryElementColor),
              ),
            ),
          );
        });
  }

  Widget _bottomView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          _verifyOtpButton(),
          const SizedBox(
            height: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SignUp_otp_screen_didnt_receive_code'.localized),
              TimerButton(
                onClick: () {
                  _otpController.clear();
                  _signUpOtpVerifyBloc
                      .add(ResendOtpCodeRequestEvent(widget.email));
                },
              )
            ],
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _verifyOtpButton() {
    return BlocBuilder<SignUpOtpVerifyBloc, SignUpOtpVerifyState>(
      bloc: _signUpOtpVerifyBloc,
      builder: (context, state) {
        if (state is SigningUpOtpVerifingState) {
          return const Center(child: Loader());
        }
        return Padding(
            padding: const EdgeInsets.all(8),
            child: AppButton(
                title: 'SignUp_otp_screen_verify_otp'.localized,
                height: 45,
                hasGradientBackground: true,
                button: PrimaryButtonDecorator(),
                appButtonState: _isVerifyOtp
                    ? AppButtonState.enabled
                    : AppButtonState.disabled,
                onClick: () {
                  _signUpOtpVerifyBloc.add(SignUpOtpVerifyRequestEvent(
                      widget.email, _otpController.text.trim()));
                }));
      },
    );
  }

  void _onStateChanged(SignUpOtpVerifyState state, BuildContext context) {
    if (state is SignedUpOtpVerifedState) {
      Utilities.showSnackBar(context,
          'Email verified successfully. Please login', SnackbarStyle.success);
      final navigator = Injector.instance<ApiLogService>().navigationKey;
      navigator?.currentState?.pushAndRemoveUntil(
        LoginScreen.route(),
        ModalRoute.withName('/InitialScreen'),
      );
    } else if (state is SignUpOtpVerifyMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is SignUpOtpVerifyFormValidationErrorState) {
      Utilities.showSnackBar(
          context,
          state.validationModel.formattedErrorMessage,
          SnackbarStyle.validationError);
    } else if (state is OtpCodeResentState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    }
  }
}
