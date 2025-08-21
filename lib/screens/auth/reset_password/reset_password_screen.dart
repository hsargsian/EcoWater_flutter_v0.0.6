import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/app_specific_widgets/timer_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/buttons/app_button_state.dart';
import '../../../base/common_widgets/buttons/decorators/primary_button_decorator.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../forgot_password/bloc/forgot_password_bloc.dart';
import '../forgot_password/bloc/forgot_password_event.dart';
import 'bloc/reset_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({required this.email, super.key});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();

  static Route<void> route(String email) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ResetPasswordScreen'),
        builder: (_) => ResetPasswordScreen(
              email: email,
            ));
  }
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObsecuredTextNewPassword = true;
  bool _isObsecuredTextConfirmPassword = true;
  bool _isVerifyOtp = false;
  late ResetPasswordBloc _bloc;
  late ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    _bloc = Injector.instance<ResetPasswordBloc>();
    _forgotPasswordBloc = Injector.instance<ForgotPasswordBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          backgroundColor: Colors.transparent,
          child: NavBar(
            navStyle: NavStyle.singleLined,
            leftButton: const LeftArrowBackButton(),
            textColor: Theme.of(context).colorScheme.primaryElementColor,
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            primary: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Check your Email',
                      style: GoogleFonts.mulish(
                          fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primaryElementColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'ResetPassword_sent_code_message'.localized,
                        style: GoogleFonts.quicksand(
                            fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primaryElementColor),
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
    );
  }

  Widget _otpView() {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state, context);
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                  child: PinCodeTextField(
                    appContext: context,
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
                        fontSize: 26, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primaryElementColor),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextField.textField(
                  context: context,
                  hint: 'ResetPassword_password_placeholder'.localized,
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _newPasswordController,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  borderColor: AppColors.tertiaryElementColor,
                  prefixIcon: _getPrefix(Icons.lock),
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        _isObsecuredTextNewPassword = !_isObsecuredTextNewPassword;
                        setState(() {});
                      },
                      icon: Icon(
                        _isObsecuredTextNewPassword ? Icons.visibility : Icons.visibility_off,
                      )),
                  isPasswordField: true,
                  isObsecured: _isObsecuredTextNewPassword,
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextField.textField(
                  context: context,
                  hint: 'ResetPassword_confirm_password_placeholder'.localized,
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _confirmPasswordController,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  borderColor: AppColors.tertiaryElementColor,
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  prefixIcon: _getPrefix(Icons.lock),
                  suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        _isObsecuredTextConfirmPassword = !_isObsecuredTextConfirmPassword;
                        setState(() {});
                      },
                      icon: Icon(
                        _isObsecuredTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      )),
                  isPasswordField: true,
                  isObsecured: _isObsecuredTextConfirmPassword,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }

  Widget _getPrefix(IconData icon) {
    return SizedBox(
      width: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 1,
            height: 35,
            color: AppColors.tertiaryElementColor,
          )
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          _verifyOtpButton(),
          const SizedBox(
            height: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ResetPassword_didnt_send_code'.localized),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                bloc: _forgotPasswordBloc,
                listener: (context, state) {
                  _onResendStateChanged(state, context);
                },
                builder: (context, state) {
                  return TimerButton(
                    onClick: () {
                      _forgotPasswordBloc.add(ForgotPasswordRequestEvent(
                        email: widget.email,
                      ));
                    },
                  );
                },
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _verifyOtpButton() {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is ResetingPasswordState) {
          return const Center(child: Loader());
        }
        return Padding(
          padding: const EdgeInsets.all(8),
          child: AppButton(
              title: 'ResetPassword_reset_button'.localized,
              height: 45,
              hasGradientBackground: true,
              button: PrimaryButtonDecorator(),
              appButtonState: _isVerifyOtp ? AppButtonState.enabled : AppButtonState.disabled,
              onClick: () {
                FocusScope.of(context).unfocus();
                _bloc.add(ResetPasswordRequestEvent(
                    widget.email, _newPasswordController.text, _confirmPasswordController.text, _otpController.text.trim()));
              }),
        );
      },
    );
  }

  void _onResendStateChanged(ForgotPasswordState state, BuildContext context) {
    if (state is ForgotPasswordRequestedState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    } else if (state is ForgotPasswordMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is ForgotPasswordValidationError) {
      Utilities.showSnackBar(context, state.validationModel.formattedErrorMessage, SnackbarStyle.validationError);
    }
  }

  void _onStateChanged(ResetPasswordState state, BuildContext context) {
    if (state is PasswordResetSuccessfulState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
      Navigator.popUntil(context, ModalRoute.withName('/login'));
    } else if (state is ResetPasswordMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is ResetPasswordFormValidationErrorState) {
      Utilities.showSnackBar(context, state.validationModel.formattedErrorMessage, SnackbarStyle.validationError);
    } else if (state is OtpCodeResentState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    }
  }
}
