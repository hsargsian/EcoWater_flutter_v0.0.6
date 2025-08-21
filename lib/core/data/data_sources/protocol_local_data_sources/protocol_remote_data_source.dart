import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/protocol_wrapper_data/protocol_category_data.dart';
import 'package:echowater/core/api/models/protocol_wrapper_data/protocol_wrapper_data.dart';
import 'package:echowater/core/domain/domain_models/protocol_type_domain.dart';
import 'package:flutter/material.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/customize_protocol_active_request_model/customize_protocol_active_request_model.dart';
import '../../../api/models/customize_protocol_model/customize_protocol_model.dart';
import '../../../api/models/customize_protocol_request_model/customize_protocol_request_model.dart';
import '../../../api/models/empty_success_response/api_success_message_response.dart';
import '../../../api/models/protocol_wrapper_data/protocol_details_data.dart';

abstract class ProtocolRemoteDataSource {
  Future<ProtocolWrapperData> fetchProtocols(
      {required int offset,
      required int perPage,
      required String? type,
      String? category});

  Future<List<ProtocolCategoryData>> fetchProtocolCategories();

  Future<ProtocolDetailsData> fetchProtocolDetails(
      String id, String protocolType);

  Future<CustomizeProtocolModel> fetchCustomizeProtocolData(String id);

  Future<CustomizeProtocolModel> saveCustomizeProtocolData(
      String id,
      CustomizeProtocolRequestModel customizeProtocolModel,
      bool isFromBlankTemplate);

  Future<ProtocolDetailsData> updateProtocolGoal(
      CustomizeProtocolActiveRequestModel customizeProtocolActiveRequestModel);

  Future<ApiSuccessMessageResponse> deleteUserProtocol(String id);
}

class ProtocolRemoteDataSourceImpl extends ProtocolRemoteDataSource {
  ProtocolRemoteDataSourceImpl(
      {required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchProtocolsCancelToken = CancelToken();
  CancelToken _fetchProtocolCategoriesCancelToken = CancelToken();

  @override
  Future<ProtocolWrapperData> fetchProtocols(
      {required int offset,
      required int perPage,
      required String? type,
      String? category}) async {
    try {
      _fetchProtocolsCancelToken.cancel();
      _fetchProtocolsCancelToken = CancelToken();

      if ((type != null && type == ProtocolType.custom.name) ||
          (category != null && category == ProtocolType.custom.name)) {
        return await _authorizedApiClient.fetchCustomProtocols(
            offset: offset, perPage: perPage);
      } else {
        if ((type != null && type == ProtocolType.topProtocols.name) ||
            (category != null && category == ProtocolType.topProtocols.name)) {
          return await _authorizedApiClient.fetchProtocols(
              offset: offset, perPage: perPage, type: type ?? category);
        }
        return await _authorizedApiClient.fetchProtocols(
            offset: offset, perPage: perPage, type: type, category: category);
      }

      // final aa = ProtocolWrapperData.dummy();
      // aa.protocols = [];
      // return aa;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<ProtocolCategoryData>> fetchProtocolCategories() async {
    try {
      _fetchProtocolCategoriesCancelToken.cancel();
      _fetchProtocolCategoriesCancelToken = CancelToken();
      final response = await _authorizedApiClient
          .fetchProtocolCategories(_fetchProtocolCategoriesCancelToken);
      return response.protocols.map((item) {
        return ProtocolCategoryData(item.name, item.id);
      }).toList();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ProtocolDetailsData> fetchProtocolDetails(
      String id, String protocolType) async {
    try {
      _fetchProtocolCategoriesCancelToken.cancel();
      _fetchProtocolCategoriesCancelToken = CancelToken();

      if (protocolType.toLowerCase() == ProtocolType.custom.name) {
        return await _authorizedApiClient.fetchCustomProtocolDetails(
            id, _fetchProtocolCategoriesCancelToken);
      } else {
        return await _authorizedApiClient.fetchProtocolDetails(
            id, _fetchProtocolCategoriesCancelToken);
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<CustomizeProtocolModel> fetchCustomizeProtocolData(String id) async {
    try {
      _fetchProtocolCategoriesCancelToken.cancel();
      _fetchProtocolCategoriesCancelToken = CancelToken();
      return await _authorizedApiClient.fetchCustomizeProtocolData(
          id, _fetchProtocolCategoriesCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<CustomizeProtocolModel> saveCustomizeProtocolData(
      String id,
      CustomizeProtocolRequestModel customizeProtocolModel,
      bool isFromBlankTemplate) async {
    try {
      if (isFromBlankTemplate) {
        return await _authorizedApiClient.createCustomProtocol(
            id, customizeProtocolModel);
      } else if (customizeProtocolModel.isTemplate) {
        return await _authorizedApiClient.createCustomProtocol(
            id, customizeProtocolModel);
      } else {
        return await _authorizedApiClient.saveCustomProtocol(
            id, customizeProtocolModel);
      }
    } catch (e) {
      debugPrint('this is the error $e');
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ProtocolDetailsData> updateProtocolGoal(
      CustomizeProtocolActiveRequestModel
          customizeProtocolActiveRequestModel) async {
    try {
      return await _authorizedApiClient
          .updateProtocolGoal(customizeProtocolActiveRequestModel);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> deleteUserProtocol(String id) async {
    try {
      return await _authorizedApiClient.deleteUserProtocol(id);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
