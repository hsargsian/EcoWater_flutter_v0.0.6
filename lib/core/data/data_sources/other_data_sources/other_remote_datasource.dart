import 'dart:io';

import '../../../api/clients/rest_client/auth_api_client/auth_api_client.dart';
import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/custom_exception.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/faq_data/faq_data.dart';
import '../../../api/models/system_access_info_data/system_access_info_data.dart';
import '../../../api/models/terms_of_service_data/terms_of_service_data.dart';

abstract class OtherRemoteDataSource {
  Future<TermsOfServiceData> fetchTermsOfService();

  Future<List<FaqData>> fetchFaqs();

  Future<SystemAccessInfoData> getSystemAccessState();
  Future<void> addNewLog(String? flaskSerialId, bool hasError, File file);
}

class OtherRemoteDataSourceImpl extends OtherRemoteDataSource {
  OtherRemoteDataSourceImpl(
      {required AuthApiClient authApiClient,
      required AuthorizedApiClient authorizedApiClient})
      : _authApiClient = authApiClient,
        _authorizedApiClient = authorizedApiClient;

  final AuthApiClient _authApiClient;
  final AuthorizedApiClient _authorizedApiClient;

  @override
  Future<TermsOfServiceData> fetchTermsOfService() async {
    try {
      final response = await _authApiClient.fetchTermsOfService();
      if (response.result.isEmpty) {
        throw CustomException.error('No terms and condition found');
      }
      return response.result.first;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<FaqData>> fetchFaqs() async {
    try {
      return await _authApiClient.fetchFaqs();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<SystemAccessInfoData> getSystemAccessState() async {
    try {
      return await _authorizedApiClient.getSystemAccessState();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<void> addNewLog(
      String? flaskSerialId, bool hasError, File file) async {
    try {
      final _ =
          await _authorizedApiClient.addNewLog(flaskSerialId, hasError, file);
      return;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
