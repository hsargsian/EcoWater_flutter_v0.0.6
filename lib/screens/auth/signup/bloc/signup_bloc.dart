import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/foundation.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/api/resource/resource.dart';
import '../../../../core/domain/domain_models/system_access_state_domain.dart';
import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../../../core/domain/entities/oauth_token_entity.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../../../../core/domain/repositories/other_repository.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../login/models/login_form_validation_model.dart';
import '../model/signup_form_validation_model.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(
      {required AuthRepository authRepository, required UserRepository userRepository, required OtherRepository otherRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        _otherRepository = otherRepository,
        super(SignUpIdleState()) {
    on<SignUpRequestEvent>(_onSignUpUser);
    on<LogInRequestEvent>(_onSubmitted);
    on<FetchUserInformationEvent>(_onFetchUserProfile);
    on<FetchSystemAccessEvent>(_onFetchSystemAccessState);
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final OtherRepository _otherRepository;
  SystemAccessStateDomain? systemAccessInfo;

  Future<void> _onFetchSystemAccessState(
    FetchSystemAccessEvent event,
    Emitter<SignUpState> emit,
  ) async {
    final response = await _otherRepository.getSystemAccessState();
    response.when(success: (responseObj) {
      systemAccessInfo = SystemAccessStateDomain(responseObj);
      emit(FetchedSystemAccessState(systemAccessInfo!));
    }, error: (error) {
      emit(SignUpMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onSignUpUser(SignUpRequestEvent event, Emitter<SignUpState> emit) async {
    // Create and validate the validation model
    final validationModel = _createValidationModelAndValidate(event);

    // If validation errors exist, emit error state and exit
    if (validationModel.hasError) {
      emit(SignUpFormValidationErrorState(validationModel));
      return;
    }
    // Emit signing up state and attempt to sign up the user
    emit(SigningUpState());
    final response = await _signUpUser(
      validationModel.firstName,
      validationModel.lastName,
      validationModel.email,
      validationModel.password,
      validationModel.confirmPassword,
      validationModel.phoneNumber,
      event.countryName,
      event.countryCode,
    );

    // Handle the response
    _handleSignUpResponse(response, emit);
  }

// Helper method to create the validation model
  SignUpFormValidationModel _createValidationModelAndValidate(SignUpRequestEvent event) {
    return SignUpFormValidationModel(
      name: event.name,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      phoneNumber: event.phoneNumber,
    )..validate();
  }

// Helper method to sign up the user
  Future<Result<ApiSuccessMessageResponseEntity>> _signUpUser(String firstName, String lastName, String email, String password,
      String confirmPassword, String phoneNumber, String countryName, String countryCode) async {
    return _authRepository.signUpUser(
        firstName, lastName, email, password, confirmPassword, phoneNumber, countryName, countryCode);
  }

// Helper method to handle the sign-up response
  void _handleSignUpResponse(Result<ApiSuccessMessageResponseEntity> response, Emitter<SignUpState> emit) {
    response.when(
      success: (signUpResponse) {
        emit(SignedUpState(signUpResponse.message));
      },
      error: (error) {
        // Use a logging package or a more robust logging approach
        if (kDebugMode) {
          print('Sign-up failed: ${error.toMessage()}');
        }
        emit(SignUpMessageState(error.toMessage(), SnackbarStyle.error));
      },
    );
  }

  Future<void> _onSubmitted(
    LogInRequestEvent event,
    Emitter<SignUpState> emit,
  ) async {
    // Create and validate the login request model
    final loginRequestModel = _createLoginRequestModelAndValidate(event);

    emit(SigningUpState());

    // Perform login and handle response
    final response = await _performLogin(loginRequestModel);
    _handleLoginResponse(response, emit);
  }

// Create a login request model with validation
  LoginRequestModel _createLoginRequestModelAndValidate(LogInRequestEvent event) {
    return LoginRequestModel(
      email: event.email,
      password: event.password,
    )..validate();
  }

// Perform the login operation
  Future<Result<OauthTokenEntity>> _performLogin(LoginRequestModel model) async {
    return _authRepository.loginUser(model);
  }

// Handle login response
  void _handleLoginResponse(Result<OauthTokenEntity> response, Emitter<SignUpState> emit) {
    response.when(
      success: (loginResponse) {
        emit(LoggedInState());
      },
      error: (error) {
        emit(SignUpMessageState(error.toMessage(), SnackbarStyle.error));
      },
    );
  }

  Future<void> _onFetchUserProfile(
    FetchUserInformationEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SigningUpState());
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(SignUpMessageState('user_session_expired_message'.localized, SnackbarStyle.error));
        Injector.instance<AuthenticationBloc>().add(ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      final profileInformation = UserDomain(userEntity, true);
      emit(ProfileFetchedState(profileInformation));
    }, error: (error) {
      emit(SignUpMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }
}
