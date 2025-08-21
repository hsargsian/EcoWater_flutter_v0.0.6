import 'dart:async';

import '../../../screens/auth/login/models/login_form_validation_model.dart';
import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../domain/entities/oauth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../injector/rest_client_module.dart';
import '../data_sources/auth_data_sources/auth_local_datasource.dart';
import '../data_sources/auth_data_sources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource, required AuthLocalDataSource localDataSource})
      : _authRemoteDataSource = remoteDataSource,
        _authLocalDataSource = localDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<Result<OauthTokenEntity>> fetchCachedToken() async {
    try {
      final tokenEntity = await _authLocalDataSource.getLastToken();
      RestClientModule.injectRefreshTokenInterceptor();
      return Result.success(tokenEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<void> logout() {
    return _authLocalDataSource.logout();
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> signUpUser(
    String firstName,
    String lastName,
    String emailAddress,
    String password,
    String confirmPassword,
    String phoneNumber,
    String countryName,
    String countryCode,
  ) async {
    try {
      final response = await _authRemoteDataSource.signUpUser(
          firstName, lastName, emailAddress, password, confirmPassword, phoneNumber, countryName, countryCode);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> verifySignUpOtp(String emailAddress, String otpCode) async {
    try {
      final response = await _authRemoteDataSource.verifySignUpOtp(emailAddress, otpCode);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> resendSignUpOtp(String emailAddress) async {
    try {
      final response = await _authRemoteDataSource.resendSignUpOtp(emailAddress);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<OauthTokenEntity>> loginUser(LoginRequestModel loginRequestModel) async {
    try {
      final response = await _authRemoteDataSource.loginUser(loginRequestModel);
      final tokenEntity = response.asEntity();
      await _authLocalDataSource.cacheToken(tokenEntity);
      RestClientModule.injectRefreshTokenInterceptor();
      return Result.success(tokenEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> requestForgotPassword(String emailAddress) async {
    try {
      final response = await _authRemoteDataSource.requestForgotPassword(emailAddress);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> requestResendResetPasswordOtpCode(String emailAddress) async {
    try {
      final response = await _authRemoteDataSource.requestResendResetPasswordOtpCode(emailAddress);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> resetPassword(
      String emailAddress, String newPassword, String confirmPassword, String securityCode) async {
    try {
      final response = await _authRemoteDataSource.resetPassword(emailAddress, newPassword, confirmPassword, securityCode);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
