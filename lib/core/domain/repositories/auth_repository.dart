import '../../../screens/auth/login/models/login_form_validation_model.dart';
import '../../api/resource/resource.dart';
import '../entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../entities/oauth_token_entity.dart';

abstract class AuthRepository {
  Future<Result<OauthTokenEntity>> loginUser(LoginRequestModel loginRequestModel);

  Future<Result<OauthTokenEntity>> fetchCachedToken();

  Future<Result<ApiSuccessMessageResponseEntity>> signUpUser(String firstname, String lastName, String emailAddress,
      String password, String confirmPassword, String phoneNumber, String countryName, String countryCode);

  Future<Result<ApiSuccessMessageResponseEntity>> verifySignUpOtp(String emailAddress, String otpCode);

  Future<Result<ApiSuccessMessageResponseEntity>> resendSignUpOtp(String emailAddress);

  Future<Result<ApiSuccessMessageResponseEntity>> requestForgotPassword(String emailAddress);

  Future<Result<ApiSuccessMessageResponseEntity>> requestResendResetPasswordOtpCode(String emailAddress);

  Future<Result<ApiSuccessMessageResponseEntity>> resetPassword(
      String emailAddress, String password, String confirmPassword, String securityCode);

  Future<void> logout();
}
