// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AuthApiClient implements AuthApiClient {
  _AuthApiClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<OauthTokenData> loginUser(
      Map<String, dynamic> loginRequestModel) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequestModel);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<OauthTokenData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = OauthTokenData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RefreshTokenData> refreshToken(String refreshToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'refresh': refreshToken};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<RefreshTokenData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/refresh',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RefreshTokenData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TermsOfServiceWrapperData> fetchTermsOfService() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TermsOfServiceWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'b_content/getTermsCondition',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = TermsOfServiceWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<FaqData>> fetchFaqs() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<FaqData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'faqs',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    var value = _result.data!
        .map((dynamic i) => FaqData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
    String phoneNumber,
    String countryName,
    String countryCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'phone_number': phoneNumber,
      'country_name': countryName,
      'country_code': countryCode,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/signup',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> verifySignUpOtp(
    String email,
    String otpCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'code': otpCode,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/verify-email',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> resendSignUpOtp(String email) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/resend-otp-code',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> requestForgotPassword(String email) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/forgot-password',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> resetPassword(
    String email,
    String password,
    String confirmPassword,
    String securityCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'new_password': password,
      'confirm_password': confirmPassword,
      'code': securityCode,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/reset-password',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> resendResetPasswordOtpCode(
      String email) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/resendResetPasswordOtpCode',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
