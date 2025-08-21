import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/buttons/decorators/primary_button_decorator.dart';
import '../../../base/common_widgets/buttons/normal_button_text.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/constants/string_constants.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../reset_password/reset_password_screen.dart';
import 'bloc/forgot_password_bloc.dart';
import 'bloc/forgot_password_event.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({required this.emailAddress, super.key});

  final String emailAddress;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

  static Route<void> route({String emailAddress = ''}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/forgotPassword'),
        builder: (_) => ForgotPasswordScreen(
              emailAddress: emailAddress,
            ));
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailAddressController = TextEditingController();
  late ForgotPasswordBloc _forgotPassswordBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _forgotPassswordBloc = Injector.instance<ForgotPasswordBloc>();
    super.initState();
    _emailAddressController.text = widget.emailAddress;
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _emailFormView(),
              ),
              _bottomView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailFormView() {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      bloc: _forgotPassswordBloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ForgotPasswordScreen_title'.localized,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontFamily: StringConstants.fieldGothicTestFont, fontWeight: FontWeight.w400)),
              Text(
                'ForgotPasswordScreen_subtitle'.localized,
                style: GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 14),
              ),
              const SizedBox(
                height: 16,
              ),
              AppTextField.textField(
                  context: context,
                  hint: 'ForgotPasswordScreen_email_placeholder'.localized,
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _emailAddressController,
                  keyboardType: TextInputType.emailAddress,
                  onTextChanged: (value) {
                    _forgotPassswordBloc.add(ValidateButtonEvent(email: value));
                  },
                  autofillHints: [AutofillHints.email],
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  borderColor: AppColors.tertiaryElementColor),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomView() {
    return SafeArea(
      child: Column(
        children: [
          _sendOtpButton(),
          const SizedBox(
            height: 25,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ForgotPasswordScreen_alreadyHaveAccount'.localized,
                style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray),
              ),
              NormalTextButton(
                title: 'ForgotPasswordScreen_loginButton'.localized,
                textColor: Theme.of(context).colorScheme.appRed,
                onClick: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _sendOtpButton() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      bloc: _forgotPassswordBloc,
      builder: (context, state) {
        if (state is ForgotPasswordRequestingState) {
          return const Center(child: Loader());
        }
        return AppButton(
            title: 'ForgotPasswordScreen_sendOtp'.localized,
            height: 45,
            hasGradientBackground: true,
            button: PrimaryButtonDecorator(),
            onClick: _onforgotPasswordButtonClick);
      },
    );
  }

  void _onforgotPasswordButtonClick() {
    if (_formKey.currentState!.validate()) {
      Utilities.dismissKeyboard();
      _forgotPassswordBloc.add(ForgotPasswordRequestEvent(
        email: _emailAddressController.text,
      ));
    }
  }

  void _onStateChanged(ForgotPasswordState state, BuildContext context) {
    if (state is ForgotPasswordRequestedState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
      Navigator.push(context, ResetPasswordScreen.route(_emailAddressController.text.trim()));
    } else if (state is ForgotPasswordMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is ForgotPasswordValidationError) {
      Utilities.showSnackBar(context, state.validationModel.formattedErrorMessage, SnackbarStyle.validationError);
    }
  }
}
