import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/empty_success_response/api_success_message_response.dart';
import '../../../models/faq_data/faq_data.dart';
import '../../../models/outh_token_data/outh_token_data.dart';
import '../../../models/outh_token_data/refresh_token_data.dart';
import '../../../models/terms_of_service_data/terms_of_service_wrapper_data.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('auth/login')
  Future<OauthTokenData> loginUser(@Body() Map<String, dynamic> loginRequestModel);

  @POST('auth/refresh')
  Future<RefreshTokenData> refreshToken(@Field('refresh') String refreshToken);

  @GET('b_content/getTermsCondition')
  Future<TermsOfServiceWrapperData> fetchTermsOfService();

  @GET('faqs')
  Future<List<FaqData>> fetchFaqs();

  @POST('auth/signup')
  Future<ApiSuccessMessageResponse> signUp(
    @Field('first_name') String firstName,
    @Field('last_name') String lastName,
    @Field() String email,
    @Field() String password,
    @Field('confirm_password') String confirmPassword,
    @Field('phone_number') String phoneNumber,
    @Field('country_name') String countryName,
    @Field('country_code') String countryCode,
  );

  @POST('auth/verify-email')
  Future<ApiSuccessMessageResponse> verifySignUpOtp(@Field() String email, @Field('code') String otpCode);

  @POST('auth/resend-otp-code')
  Future<ApiSuccessMessageResponse> resendSignUpOtp(@Field() String email);

  @POST('auth/forgot-password')
  Future<ApiSuccessMessageResponse> requestForgotPassword(@Field() String email);

  @POST('auth/reset-password')
  Future<ApiSuccessMessageResponse> resetPassword(@Field() String email, @Field('new_password') String password,
      @Field('confirm_password') String confirmPassword, @Field('code') String securityCode);

  @POST('auth/resendResetPasswordOtpCode')
  Future<ApiSuccessMessageResponse> resendResetPasswordOtpCode(@Field() String email);

// @GET('system-access')
// Future<SystemAccessInfoData> getSystemAccessState();
}
