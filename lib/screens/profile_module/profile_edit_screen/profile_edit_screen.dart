import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/phone_number_field/phone_number_textfield.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import '../../../oc_libraries/media_picker/media_picker_config.dart';
import '../../../oc_libraries/media_picker/media_picker_service.dart';
import '../../../oc_libraries/media_picker/media_source.dart';
import '../../../oc_libraries/media_picker/media_type.dart';
import 'bloc/profile_edit_bloc.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({this.didUpdateProfile, super.key});

  final Function? didUpdateProfile;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();

  static Route<void> route({Function()? didUpdateProfile}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ProfileEditScreen'),
        builder: (_) => ProfileEditScreen(
              didUpdateProfile: didUpdateProfile,
            ));
  }
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final ProfileEditBloc _bloc;
  final _emailFieldController = TextEditingController();
  final _firstNameFieldController = TextEditingController();
  final _lastNameFieldController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<PhoneNumberPickerTextFieldState>
      _phoneNumberPickerTextFieldState = GlobalKey();

  @override
  void initState() {
    _bloc = Injector.instance<ProfileEditBloc>();
    super.initState();
    _bloc.add(FetchUserInformationEvent());
  }

  void _onProfileUpdate() {
    Utilities.dismissKeyboard();
    _bloc.add(ProfileEditRequestEvent(
        _firstNameFieldController.text,
        _lastNameFieldController.text,
        _phoneNumberPickerTextFieldState.currentState!.getPhoneNumber(),
        _phoneNumberPickerTextFieldState.currentState!.getCountryName(),
        _phoneNumberPickerTextFieldState.currentState!.getCountryCode()));
  }

  Widget _profileImageViewWrapper() {
    return BlocBuilder<ProfileEditBloc, ProfileEditState>(
      bloc: _bloc,
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: AppImageView(
                borderColor: Theme.of(context)
                    .colorScheme
                    .primaryElementColor
                    .withValues(alpha: 0.9),
                borderWidth: 1,
                height: 70,
                width: 70,
                cornerRadius: 35,
                placeholderHeight: 70,
                placeholderWidth: 70,
                avatarUrl: _bloc.profileInformation?.primaryImageUrl(),
                backgroundColor: AppColors.colorD9D9D9,
                selectedImage: _bloc.selectedProfileImage,
                placeholderImage: Images.userPlaceholder,
                onTapped: () {
                  _onChangeProfileImage();
                },
              ),
            ),
            Positioned(
                child: InkWell(
                    onTap: _onChangeProfileImage,
                    child: SvgPicture.asset(Images.editIcon)))
          ],
        );
      },
    );
  }

  Future<void> _onChangeProfileImage() async {
    MediaPickerService().initiateMediaPick(
      context: context,
      types: [MediaType.image],
      sources: [MediaSource.camera, MediaSource.gallery],
      config: MediaPickerConfig(
          cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)),
      onSuccess: (p0) {
        if (p0.isEmpty) {
          return;
        }
        _bloc.add(PerformProfileImagePickEvent(p0.first.file));
      },
      onError: (p0) {
        Utilities.showSnackBar(context, p0 ?? 'Error', SnackbarStyle.error);
      },
    );
  }

  Widget _formFieldsView() {
    return BlocConsumer<ProfileEditBloc, ProfileEditState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state);
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField.textField(
                      verticalPadding: 10,
                      context: context,
                      hint: 'ProfileEditScreen_FirstNamePlaceholder'.localized,
                      validator: () => null,
                      textCapitalization: TextCapitalization.none,
                      controller: _firstNameFieldController,
                      backgroundColor: AppColors.transparent,
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
                      hint: 'ProfileEditScreen_LastNamePlaceholder'.localized,
                      verticalPadding: 10,
                      validator: () => null,
                      textCapitalization: TextCapitalization.none,
                      controller: _lastNameFieldController,
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
            Opacity(
              opacity: 0.5,
              child: AppTextField.textField(
                  context: context,
                  hint: 'ProfileEditScreen_EmailPlaceholder'.localized,
                  verticalPadding: 10,
                  suffixIcon: const Icon(Icons.lock),
                  validator: () => null,
                  textCapitalization: TextCapitalization.none,
                  controller: _emailFieldController,
                  keyboardType: TextInputType.none,
                  backgroundColor: AppColors.transparent,
                  hasMandatoryBorder: true,
                  textColor: Theme.of(context).colorScheme.primaryElementColor,
                  borderColor: AppColors.tertiaryElementColor),
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
              onSubmitted: (countryCode, phoneNumber, countryName) {},
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }

  void _onStateChanged(ProfileEditState state) {
    if (state is ProfileUpdateCompleteState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);

      Navigator.pop(context);
      widget.didUpdateProfile?.call();
    } else if (state is ProfileEditApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is ProfileEditFormValidationErrorState) {
      Utilities.showSnackBar(
          context,
          state.validationModel.formattedErrorMessage,
          SnackbarStyle.validationError);
    } else if (state is ProfileFetchedState) {
      _firstNameFieldController.text = state.userProfile.firstName;
      _lastNameFieldController.text = state.userProfile.lastName;
      _emailFieldController.text = state.userProfile.email;
      _phoneNumberPickerTextFieldState.currentState?.setPhoneNumberAndCountry(
          state.userProfile.phoneNumber, state.userProfile.countryName);

      setState(() {});
    } else if (state is UpdatingProfileState) {
      const Loader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
        bloc: _bloc,
        builder: (context, state) {
          return SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  NormalTextButton(
                    title: 'ProfileEditScreen_cancel'.localized,
                    fontSize: 20,
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: StringConstants.fieldGothicTestFont),
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                      child: Text(
                    'ProfileEditScreen_EditProfile'.localized,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: StringConstants.fieldGothicTestFont),
                    textAlign: TextAlign.center,
                  )),
                  state is UpdatingProfileState
                      ? const Align(
                          alignment: Alignment.bottomCenter, child: Loader())
                      : NormalTextButton(
                          title: 'ProfileEditScreen_Done'.localized,
                          fontSize: 20,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily:
                                      StringConstants.fieldGothicTestFont),
                          onClick: () {
                            _onProfileUpdate();
                          },
                        ),
                ],
              ),
            ),
          );
        },
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            AppBoxedContainer(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'ProfileEditScreen_headerTitle'.localized,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileImageViewWrapper(),
                    const SizedBox(
                      height: 10,
                    ),
                    _formFieldsView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
