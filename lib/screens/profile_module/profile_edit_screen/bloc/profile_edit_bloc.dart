import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../../theme/app_theme_manager.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';
import '../model/profile_update_form_validation_model.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileEditIdleState()) {
    on<FetchUserInformationEvent>(_onFetchProfileDetail);
    on<ProfileEditRequestEvent>(_onUpdateProfile);
    on<ProfilePictureEditEvent>(_onUpdateProfilePicture);
    on<PerformProfileImagePickEvent>(_onPickProfileImage);
  }

  final UserRepository _userRepository;

  XFile? selectedProfileImage;
  UserDomain? profileInformation;

  Future<void> _onUpdateProfile(ProfileEditRequestEvent event, Emitter<ProfileEditState> emit) async {
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(ProfileEditApiErrorState('user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    final formValidationResponse =
        ProfileUpdateFormValidationModel(event.firstName, event.lastName, event.phoneNumber).validate();
    if (formValidationResponse != null) {
      emit(ProfileEditFormValidationErrorState(formValidationResponse));
      return;
    }
    emit(UpdatingProfileState());
    final response = await _userRepository.updateUser(
        event.firstName, event.lastName, event.phoneNumber, event.countryName, event.countryCode, null);
    response.when(success: (updateResponse) {
      if (selectedProfileImage != null) {
        add(ProfilePictureEditEvent(selectedProfileImage!));
      } else {
        selectedProfileImage = null;
        emit(ProfileUpdateCompleteState('ProfileEditScreen_profileUpdateSuccess'.localized));
      }
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onUpdateProfilePicture(ProfilePictureEditEvent event, Emitter<ProfileEditState> emit) async {
    emit(UpdatingProfileState());
    final response = await _userRepository.updateProfileImage(
      image: File(event.avatar.path),
    );
    response.when(success: (updateResponse) {
      selectedProfileImage = null;
      emit(ProfileUpdateCompleteState('ProfileEditScreen_profileUpdateSuccess'.localized));
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onPickProfileImage(PerformProfileImagePickEvent event, Emitter<ProfileEditState> emit) async {
    selectedProfileImage = event.image;
    if (selectedProfileImage != null) {
      add(ProfilePictureEditEvent(selectedProfileImage!));
    }
  }

  Future<void> _onFetchProfileDetail(FetchUserInformationEvent event, Emitter<ProfileEditState> emit) async {
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(ProfileEditApiErrorState('User session has expired'));
        Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      profileInformation = UserDomain(userEntity, true);
      AppThemeManager().changeTheme(profileInformation!.theme);
      emit(ProfileFetchedState(profileInformation!));
    }, error: (error) {
      emit(ProfileEditApiErrorState(error.toMessage()));
    });
  }
}
