import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/api/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/resource/resource.dart';
import '../../../../core/domain/domain_models/user_domain.dart';
import '../../../../core/domain/entities/oauth_token_entity.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../../../../core/domain/repositories/other_repository.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../models/login_form_validation_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
      {required AuthRepository authenticationRepository,
      required UserRepository userRepository,
      required OtherRepository otherRepository})
      : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _otherRepository = otherRepository,
        super(LogInIdleState()) {
    on<LogInRequestEvent>(_onSubmitted);
    on<FormFieldValueChangedEvent>(_onFormValueChanged);
    on<FetchUserInformationEvent>(_onFetchUserProfile);
  }
  final AuthRepository _authenticationRepository;
  final UserRepository _userRepository;
  final OtherRepository _otherRepository;

  Future<void> _onFetchUserProfile(
    FetchUserInformationEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoggingInState());
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      if (currentUserId == null) {
        emit(LoginApiErrorState('user_session_expired_message'.localized));
        Injector.instance<AuthenticationBloc>().add(
            ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        return;
      }
    }
    final response = await _userRepository.fetchUserDetails();
    response.when(success: (userEntity) {
      final profileInformation = UserDomain(userEntity, true);
      emit(ProfileFetchedState(profileInformation));
    }, error: (error) {
      emit(LoginApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onSubmitted(
    LogInRequestEvent event,
    Emitter<LoginState> emit,
  ) async {
    // Create and validate the login request model
    final loginRequestModel = _createLoginRequestModelAndValidate(event);

    if (loginRequestModel.hasError) {
      emit(LogInFormValidationErrorState(loginRequestModel));
      return;
    }

    emit(LoggingInState());

    // Perform login and handle response
    final response = await _performLogin(loginRequestModel);
    _handleLoginResponse(response, emit);
  }

// Create a login request model with validation
  LoginRequestModel _createLoginRequestModelAndValidate(
      LogInRequestEvent event) {
    return LoginRequestModel(
      email: event.email,
      password: event.password,
    )..validate();
  }

// Perform the login operation
  Future<Result<OauthTokenEntity>> _performLogin(
      LoginRequestModel model) async {
    return _authenticationRepository.loginUser(model);
  }

// Handle login response
  void _handleLoginResponse(
      Result<OauthTokenEntity> response, Emitter<LoginState> emit) {
    response.when(
      success: (loginResponse) {
        emit(LoggedInState());
      },
      error: (error) {
        if (error == CustomException.emailNotVerified()) {
          emit(UnverifiedUserState());
          return;
        }
        emit(LoginApiErrorState(error.toMessage()));
      },
    );
  }

  Future<void> _onFormValueChanged(
    FormFieldValueChangedEvent event,
    Emitter<LoginState> emit,
  ) async {
    // Create and validate the login request model
    final loginRequestModel = LoginRequestModel(
      email: event.email,
      password: event.password,
    )..validate();

    if (loginRequestModel.hasError) {
      emit(LogInFormValidationErrorState(loginRequestModel));
      return;
    }
    emit(LogInFormValidState());
  }
}
