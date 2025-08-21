import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_app_intro_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/buttons/normal_button_text.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/constants/string_constants.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/user_domain.dart';
import '../../../core/injector/injector.dart';
import '../authentication/bloc/authentication_bloc.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../signup_otp_verify/signup_otp_verify.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/login'),
        builder: (_) => const LoginScreen());
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailAddressController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObsecuredText = true;
  final _formKey = GlobalKey<FormState>();

  late final LoginBloc _loginBloc;
  UserDomain? profileInformation;

  @override
  void initState() {
    _loginBloc = Injector.instance<LoginBloc>();
    super.initState();

    if (kDebugMode) {
      _emailAddressController.text = 'john.doe@test.com';
      _passwordController.text = 'TestPassword123';
    }
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          stops: const [0.2, 0.4, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorC3A2B3,
            AppColors.colorC3A2B3,
            Theme.of(context).colorScheme.primary
          ],
        )),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(child: _backgroundView()),
              BlocConsumer<LoginBloc, LoginState>(
                bloc: _loginBloc,
                listener: (context, state) {
                  _onStateChanged(state, context);
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    primary: true,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: SvgPicture.asset(
                                    Images.loginGradient,
                                    width: 200,
                                    height: 400,
                                    fit: BoxFit.fill,
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    _loginFormView(),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    _bottomView(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backgroundView() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            Images.onboardingInitial,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            SvgPicture.asset(
              Images.navBarLogo,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      ],
    );
  }

  Widget _loginFormView() {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {
        final hasEmailError = (state is LogInFormValidationErrorState) &&
            state.validationModel.hasEmailError;
        final hasPasswordError = (state is LogInFormValidationErrorState) &&
            state.validationModel.hasPasswordError;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text('LoginScreen_login'.localized,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: StringConstants.fieldGothicTestFont,
                      fontWeight: FontWeight.w400)),
              const SizedBox(
                height: 20,
              ),
              AppTextField.textField(
                context: context,
                hint: 'LoginScreen_EmailPlaceholder'.localized,
                validator: () => null,
                textCapitalization: TextCapitalization.none,
                controller: _emailAddressController,
                keyboardType: TextInputType.emailAddress,
                hasError: hasEmailError,
                backgroundColor: AppColors.transparent,
                hasMandatoryBorder: true,
                onTextChanged: (p0) {
                  if (state is LogInFormValidationErrorState) {
                    _loginBloc.add(FormFieldValueChangedEvent(
                        email: _emailAddressController.text,
                        password: _passwordController.text));
                  }
                },
                borderColor: AppColors.tertiaryElementColor,
                textColor: Theme.of(context).colorScheme.primaryElementColor,
              ),
              const SizedBox(
                height: 16,
              ),
              AppTextField.textField(
                  context: context,
                  hint: 'LoginScreen_PasswordPlaceholder'.localized,
                  controller: _passwordController,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  borderColor: AppColors.tertiaryElementColor,
                  validator: () => null,
                  onTextChanged: (p0) {
                    if (state is LogInFormValidationErrorState) {
                      _loginBloc.add(FormFieldValueChangedEvent(
                          email: _emailAddressController.text,
                          password: _passwordController.text));
                    }
                  },
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  onObscureTapped: () {
                    setState(() {
                      _isObsecuredText = !_isObsecuredText;
                    });
                  },
                  suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        _isObsecuredText = !_isObsecuredText;
                        setState(() {});
                      },
                      icon: Icon(
                        _isObsecuredText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      )),
                  isPasswordField: true,
                  isObsecured: _isObsecuredText,
                  hasError: hasPasswordError),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    NormalTextButton(
                      textColor:
                          Theme.of(context).colorScheme.primaryElementColor,
                      title: 'LoginScreen_ForgotPassword'.localized,
                      onClick: _showForgotPasswordView,
                    ),
                  ],
                ),
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
          Row(
            children: [
              Expanded(
                  child: AppButton(
                      title: 'LoginScreen_BackButton'.localized,
                      height: 50,
                      radius: 50,
                      elevation: 0,
                      backgroundColor: AppColors.transparent,
                      border: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryElementColor),
                      textColor:
                          Theme.of(context).colorScheme.primaryElementColor,
                      onClick: () {
                        Navigator.pop(context);
                      })),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: _loginButton())
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoggingInState) {
          return Center(
            child: Loader(
              color: Theme.of(context).colorScheme.primaryElementColor,
            ),
          );
        }

        return AppButton(
            title: 'LoginScreen_loginButton'.localized,
            height: 50,
            radius: 50,
            elevation: 5,
            backgroundColor: Theme.of(context).colorScheme.primaryElementColor,
            textColor: Theme.of(context).scaffoldBackgroundColor,
            onClick: _onLoginButtonClick);
      },
    );
  }

  void _onLoginButtonClick() {
    if (_formKey.currentState!.validate()) {
      Utilities.dismissKeyboard();
      _loginBloc.add(LogInRequestEvent(
          email: _emailAddressController.text,
          password: _passwordController.text));
    }
  }

  void _onStateChanged(LoginState state, BuildContext context) {
    if (state is LoggedInState) {
      _loginBloc.add(FetchUserInformationEvent());
    } else if (state is LoginApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is LogInFormValidationErrorState) {
      Utilities.showSnackBar(
          context,
          state.validationModel.formattedErrorMessage,
          SnackbarStyle.validationError);
    } else if (state is UnverifiedUserState) {
      Utilities.showSnackBar(context,
          'LoginScreen_notVerifiedMessage'.localized, SnackbarStyle.error);
      Navigator.push(
          context, SignupOtpVerifyScreen.route(_emailAddressController.text));
    } else if (state is ProfileFetchedState) {
      if (state.userProfile.hasPairedDevice) {
        Injector.instance<AuthenticationBloc>()
            .add(AuthenticationCheckUserSessionEvent());
      } else {
        Navigator.push(
            context, OnboardingAppIntroScreen.route(isFromProfile: false));
      }
    }
  }

  void _showForgotPasswordView() {
    Navigator.push(context,
        ForgotPasswordScreen.route(emailAddress: _emailAddressController.text));
  }
}
