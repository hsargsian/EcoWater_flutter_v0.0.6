import 'package:echowater/base/common_widgets/buttons/decorators/primary_button_decorator.dart';
import 'package:echowater/base/common_widgets/phone_number_field/phone_number_textfield.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/screens/auth/login/login.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/buttons/app_button_state.dart';
import '../../../base/common_widgets/buttons/normal_button_text.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/signup_terms_agree_view.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/constants/string_constants.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/user_type.dart';
import '../../../core/injector/injector.dart';
import '../../onboarding_flow/onboarding_app_intro_screen.dart';
import '../authentication/bloc/authentication_bloc.dart';
import '../signup_otp_verify/signup_otp_verify.dart';
import 'bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({required this.userType, super.key});

  final UserType userType;

  @override
  State<SignupScreen> createState() => _SignupScreenState();

  static Route<void> route({required UserType userType}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/signup'),
        builder: (_) => SignupScreen(
              userType: userType,
            ));
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameFieldController = TextEditingController();
  final _lastNameFieldController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<PhoneNumberPickerTextFieldState>
      _phoneNumberPickerTextFieldState = GlobalKey();
  bool _isObsecuredText = true;
  final _formKey = GlobalKey<FormState>();
  bool _isSignUpEnabled = false;
  final FocusNode _passwordFieldFocusNode = FocusNode();
  final ValueNotifier<bool> _passwordInfoNotifier = ValueNotifier<bool>(false);

  late SignUpBloc _signUpBloc;

  @override
  void initState() {
    _signUpBloc = Injector.instance<SignUpBloc>();
    super.initState();
    if (kDebugMode) {
      _firstNameFieldController.text = 'Ashwin';
      _lastNameFieldController.text = 'Shrestha';
      _confirmPasswordController.text = 'Apple!23';
      _emailAddressController.text = 'ashwinshres+@gmail.com';
      _passwordController.text = 'Apple!23';
      _phoneController.text = '11111111';
    }
    _passwordFieldFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _passwordController.dispose();
    _passwordFieldFocusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_passwordFieldFocusNode.hasFocus) {
      _passwordInfoNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(child: _backgroundView()),
            BlocBuilder<SignUpBloc, SignUpState>(
              bloc: _signUpBloc,
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
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  Images.signupGradientBackground,
                                  width: 200,
                                  height: 400,
                                  fit: BoxFit.fill,
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  Text('SignUp_title'.localized,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontFamily: StringConstants
                                                  .fieldGothicTestFont,
                                              fontWeight: FontWeight.w400)),
                                  _signUpFormView(),
                                  const SizedBox(
                                    height: 30,
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

  Widget _signUpFormView() {
    return BlocConsumer<SignUpBloc, SignUpState>(
      bloc: _signUpBloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                          context: context,
                          hint: 'SignUp_firstName_placeholder'.localized,
                          validator: () => null,
                          textCapitalization: TextCapitalization.none,
                          controller: _firstNameFieldController,
                          backgroundColor: AppColors.transparent,
                          autofillHints: [AutofillHints.givenName],
                          hasMandatoryBorder: true,
                          textColor:
                              Theme.of(context).colorScheme.primaryElementColor,
                          borderColor: AppColors.tertiaryElementColor),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppTextField.textField(
                          context: context,
                          hint: 'SignUp_lastName_placeholder'.localized,
                          validator: () => null,
                          textCapitalization: TextCapitalization.none,
                          controller: _lastNameFieldController,
                          autofillHints: [AutofillHints.familyName],
                          backgroundColor: AppColors.transparent,
                          hasMandatoryBorder: true,
                          textColor:
                              Theme.of(context).colorScheme.primaryElementColor,
                          borderColor: AppColors.tertiaryElementColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                PhoneNumberPickerTextField(
                  key: _phoneNumberPickerTextFieldState,
                  hasError: false,
                  text: '',
                  showsContactPicker: false,
                  phoneNumberController: _phoneController,
                  onSubmitted: (String countryCode, String phoneNumber,
                      String countryName) {},
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextField.textField(
                    context: context,
                    hint: 'SignUp_email_placeholder'.localized,
                    validator: () => null,
                    textCapitalization: TextCapitalization.none,
                    controller: _emailAddressController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                    backgroundColor: AppColors.transparent,
                    hasMandatoryBorder: true,
                    textColor:
                        Theme.of(context).colorScheme.primaryElementColor,
                    borderColor: AppColors.tertiaryElementColor),
                const SizedBox(
                  height: 16,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _passwordInfoNotifier,
                  builder: (context, value, child) {
                    return value
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: StringConstants.passwordRequirements
                                  .map((item) => Text(
                                        item,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondaryElementColor),
                                      ))
                                  .toList(),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                AppTextField.textField(
                  focusNode: _passwordFieldFocusNode,
                  context: context,
                  onTap: () {
                    _passwordInfoNotifier.value = true;
                  },
                  onFieldSubmitted: (p0) {
                    _passwordInfoNotifier.value = false;
                  },
                  hint: 'SignUp_password_placeholder'.localized,
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _passwordController,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  borderColor: AppColors.tertiaryElementColor,
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
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextField.textField(
                  context: context,
                  hint: 'SignUp_confirmPassword_placeholder'.localized,
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _confirmPasswordController,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  borderColor: AppColors.tertiaryElementColor,
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
                ),
                const SizedBox(
                  height: 16,
                ),
                SignUpTermsAgreeView(
                  onSelectionChanged: (p0) {
                    _isSignUpEnabled = p0;
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          _signupButton(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                'SignUp_already_have_account'.localized,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primaryElementColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              )),
              NormalTextButton(
                title: 'SignUp_signIn_button'.localized,
                textColor: Theme.of(context).colorScheme.primary,
                onClick: () {
                  Navigator.push(context, LoginScreen.route());
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _signupButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      bloc: _signUpBloc,
      builder: (context, state) {
        if (state is SigningUpState) {
          return const Center(child: Loader());
        }
        return AppButton(
            title: 'SignUp_signUp_button'.localized,
            height: 45,
            hasGradientBackground: true,
            button: PrimaryButtonDecorator(),
            appButtonState: _isSignUpEnabled
                ? AppButtonState.enabled
                : AppButtonState.disabled,
            onClick: _onSignUpButtonClick);
      },
    );
  }

  void _onSignUpButtonClick() {
    if (_formKey.currentState!.validate()) {
      Utilities.dismissKeyboard();
      _signUpBloc.add(SignUpRequestEvent(
          _firstNameFieldController.text,
          _lastNameFieldController.text,
          _emailAddressController.text,
          _passwordController.text,
          _confirmPasswordController.text,
          _phoneNumberPickerTextFieldState.currentState!.getPhoneNumber(),
          _phoneNumberPickerTextFieldState.currentState!.getCountryName(),
          _phoneNumberPickerTextFieldState.currentState!.getCountryCode()));
    }
  }

  void _clearFileds() {
    _firstNameFieldController.clear();
    _lastNameFieldController.clear();
    _confirmPasswordController.clear();
    _emailAddressController.clear();
    _passwordController.clear();
    _phoneNumberPickerTextFieldState.currentState
        ?.setPhoneNumberAndCountry('', 'US');
  }

  void _onStateChanged(SignUpState state, BuildContext context) {
    if (state is SignedUpState) {
      Navigator.push(
          context, SignupOtpVerifyScreen.route(_emailAddressController.text));
      _clearFileds();
    } else if (state is SignUpMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is SignUpFormValidationErrorState) {
      Utilities.showSnackBar(
          context,
          state.validationModel.formattedErrorMessage,
          SnackbarStyle.validationError);
    } else if (state is LoggedInState) {
      _signUpBloc.add(FetchSystemAccessEvent());
    } else if (state is ProfileFetchedState) {
      final systemAccessInfo = _signUpBloc.systemAccessInfo!;
      if (systemAccessInfo.canAccessSystem) {
        if (state.userProfile.hasPairedDevice) {
          _openDashboard();
        } else {
          Navigator.push(
              context, OnboardingAppIntroScreen.route(isFromProfile: false));
        }
      } else {
        _openDashboard();
      }
    } else if (state is FetchedSystemAccessState) {
      _signUpBloc.add(FetchUserInformationEvent());
    }
  }

  void _openDashboard() {
    Injector.instance<AuthenticationBloc>()
        .add(AuthenticationCheckUserSessionEvent());
  }
}
