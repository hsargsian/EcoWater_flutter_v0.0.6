import 'package:echowater/core/api/resource/resource.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/customize_protocol_entity/customize_protocol_entity.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_wrapper_entity.dart';

import '../entities/CustomizeProtocolActiveRequestEntity/customize_protocol_active_request_entity.dart';
import '../entities/protocol_wrapper_entity/protocol_category_entity.dart';

abstract class ProtocolRepository {
  Future<Result<ProtocolWrapperEntity>> fetchProtocols(
      {required int offset, required int perPage, required String? type, String? category});

  Future<Result<List<ProtocolCategoryEntity>>> fetchProtocolCategories();

  Future<Result<ProtocolDetailsEntity>> fetchProtocolDetails(String id, String protcolType);

  Future<Result<CustomizeProtocolEntity>> fetchCustomizeProtocolData(String id);

  Future<Result<CustomizeProtocolEntity>> saveCustomizeProtocolData(
      String id, CustomizeProtocolEntity customizeProtocolModel, bool isFromBlankTemplate);

  Future<Result<ProtocolDetailsEntity>> updateProtocolGoal(
      CustomizeProtocolActiveRequestEntity customizeProtocolActiveRequestEntity);

  Future<Result<ApiSuccessMessageResponseEntity>> deleteUserProtocol(String id);
}
