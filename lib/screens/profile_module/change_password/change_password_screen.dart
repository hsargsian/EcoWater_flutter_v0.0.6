import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/buttons/app_button.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import 'bloc/change_password_bloc.dart';

class ChangePassworScreen extends StatefulWidget {
  const ChangePassworScreen({super.key});

  @override
  State<ChangePassworScreen> createState() => _ChangePassworScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/changePasswordScreen'),
        builder: (_) => const ChangePassworScreen());
  }
}

class _ChangePassworScreenState extends State<ChangePassworScreen> {
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObsecuredText = true;
  bool _isObsecuredTextNewPassword = true;
  bool _isObsecuredTextConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  late ChangePasswordBloc _changePassworBloc;
  @override
  void initState() {
    _changePassworBloc = Injector.instance<ChangePasswordBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
        navStyle: NavStyle.singleLined,
        leftButton: const LeftArrowBackButton(),
        navTitle: 'ChangePasswordScreen_ChangePasswordTitle'.localized,
        textColor: Theme.of(context).colorScheme.primaryElementColor,
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          primary: true,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    _changePasswordView(),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                _bottomView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _changePasswordView() {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      bloc: _changePassworBloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              AppTextField.textField(
                context: context,
                hint:
                    'ChangePasswordScreen_ChangePasswordPlaceholder'.localized,
                validator: () => null,
                textCapitalization: TextCapitalization.none,
                controller: _currentPasswordController,
                backgroundColor: AppColors.transparent,
                hasMandatoryBorder: true,
                borderColor: AppColors.tertiaryElementColor,
                textColor: Theme.of(context).colorScheme.primaryElementColor,
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
                hint:
                    'ChangePasswordScreen_ChangePasswordNewPassword'.localized,
                validator: () => null,
                textCapitalization: TextCapitalization.none,
                controller: _passwordController,
                backgroundColor: AppColors.transparent,
                hasMandatoryBorder: true,
                borderColor: AppColors.tertiaryElementColor,
                textColor: Theme.of(context).colorScheme.primaryElementColor,
                suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: () {
                      _isObsecuredTextNewPassword =
                          !_isObsecuredTextNewPassword;
                      setState(() {});
                    },
                    icon: Icon(
                      _isObsecuredTextNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    )),
                isPasswordField: true,
                isObsecured: _isObsecuredTextNewPassword,
              ),
              const SizedBox(
                height: 16,
              ),
              AppTextField.textField(
                context: context,
                hint: 'ChangePasswordScreen_ChangePasswordConfirmPassword'
                    .localized,
                validator: () => null,
                textCapitalization: TextCapitalization.none,
                controller: _confirmPasswordController,
                backgroundColor: AppColors.transparent,
                hasMandatoryBorder: true,
                borderColor: AppColors.tertiaryElementColor,
                textColor: Theme.of(context).colorScheme.primaryElementColor,
                suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: () {
                      _isObsecuredTextConfirmPassword =
                          !_isObsecuredTextConfirmPassword;
                      setState(() {});
                    },
                    icon: Icon(
                      _isObsecuredTextConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
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
      },
    );
  }

  Widget _bottomView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          _sendOtpButton(),
          const SizedBox(
            height: 25,
          ),
          const SizedBox(
            height: 220,
          ),
        ],
      ),
    );
  }

  Widget _sendOtpButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      bloc: _changePassworBloc,
      builder: (context, state) {
        if (state is ChangePasswordRequestingState) {
          return const Center(child: Loader());
        }
        return AppButton(
            title: 'ChangePasswordScreen_ChangePasswordButton'.localized,
            height: 50,
            radius: 50,
            hasGradientBackground: true,
            elevation: 5,
            onClick: _onChangePasswordButtonClick);
      },
    );
  }

  void _onChangePasswordButtonClick() {
    if (_formKey.currentState!.validate()) {
      Utilities.dismissKeyboard();
      _changePassworBloc.add(ChangePasswordRequestEvent(
          confirmPassword: _confirmPasswordController.text.trim(),
          newPassword: _passwordController.text.trim(),
          currentPassword: _currentPasswordController.text.trim()));
    }
  }

  void _onStateChanged(ChangePasswordState state, BuildContext context) {
    if (state is ChangePasswordIdleState) {
    } else if (state is ChangePassswordApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is ChangePasswordValidationError) {
      Utilities.showSnackBar(
          context,
          state.validationModel.formattederrorMessage,
          SnackbarStyle.validationError);
    } else if (state is ChangePasswordRequestedState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
      Navigator.pop(context);
    }
  }
}
