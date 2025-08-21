import '../../../../screens/auth/login/models/login_form_validation_model.dart';
import '../../../api/clients/rest_client/auth_api_client/auth_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/empty_success_response/api_success_message_response.dart';
import '../../../api/models/outh_token_data/outh_token_data.dart';
import '../../../api/models/outh_token_data/refresh_token_data.dart';

abstract class AuthRemoteDataSource {
  Future<OauthTokenData> loginUser(LoginRequestModel loginRequestModel);

  Future<RefreshTokenData> refreshToken(String refreshToken);

  Future<ApiSuccessMessageResponse> signUpUser(
    String firstName,
    String lastName,
    String emailAddress,
    String password,
    String confirmPassword,
    String phoneNumber,
    String countryName,
    String countryCode,
  );

  Future<ApiSuccessMessageResponse> verifySignUpOtp(String emailAddress, String otpCode);

  Future<ApiSuccessMessageResponse> resendSignUpOtp(String emailAddress);

  Future<ApiSuccessMessageResponse> requestForgotPassword(String emailAddress);

  Future<ApiSuccessMessageResponse> requestResendResetPasswordOtpCode(String emailAddress);

  Future<ApiSuccessMessageResponse> resetPassword(
      String emailAddress, String newPassword, String confirmPassword, String securityCode);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required AuthApiClient authApiClient}) : _authApiClient = authApiClient;

  final AuthApiClient _authApiClient;

  @override
  Future<RefreshTokenData> refreshToken(String refreshToken) async {
    try {
      return await _authApiClient.refreshToken(refreshToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<OauthTokenData> loginUser(LoginRequestModel loginRequestModel) async {
    try {
      final json = <String, dynamic>{'email': loginRequestModel.email, 'password': loginRequestModel.password};
      final loginData = await _authApiClient.loginUser(json);
      return loginData;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> signUpUser(
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
      return await _authApiClient.signUp(
          firstName, lastName, emailAddress, password, confirmPassword, phoneNumber, countryName, countryCode);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> verifySignUpOtp(String emailAddress, String otpCode) async {
    try {
      return await _authApiClient.verifySignUpOtp(emailAddress, otpCode);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> resendSignUpOtp(String emailAddress) async {
    try {
      return await _authApiClient.resendSignUpOtp(emailAddress);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> requestForgotPassword(String emailAddress) async {
    try {
      return await _authApiClient.requestForgotPassword(emailAddress);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> requestResendResetPasswordOtpCode(String emailAddress) async {
    try {
      return await _authApiClient.resendResetPasswordOtpCode(emailAddress);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> resetPassword(
    String emailAddress,
    String newPassword,
    String confirmPassword,
    String securityCode,
  ) async {
    try {
      return await _authApiClient.resetPassword(emailAddress, newPassword, confirmPassword, securityCode);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
