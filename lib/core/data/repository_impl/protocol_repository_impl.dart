import 'package:echowater/core/api/resource/resource.dart';
import 'package:echowater/core/domain/entities/CustomizeProtocolActiveRequestEntity/customize_protocol_active_request_entity.dart';
import 'package:echowater/core/domain/entities/customize_protocol_entity/customize_protocol_entity.dart';
import 'package:echowater/core/domain/entities/protocol_details_entity/protocol_details_entity.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_category_entity.dart';
import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_wrapper_entity.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../api/models/customize_protocol_active_request_model/customize_protocol_active_request_model.dart';
import '../../api/models/customize_protocol_request_model/customize_protocol_request_model.dart';
import '../../domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../domain/repositories/protocol_repository.dart';
import '../data_sources/protocol_local_data_sources/protocol_local_data_source.dart';
import '../data_sources/protocol_local_data_sources/protocol_remote_data_source.dart';

class ProtocolRepositoryImpl implements ProtocolRepository {
  ProtocolRepositoryImpl({required ProtocolRemoteDataSource remoteDataSource, required ProtocolLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ProtocolRemoteDataSource _remoteDataSource;
  final ProtocolLocalDataSource _localDataSource;

  @override
  Future<Result<ProtocolWrapperEntity>> fetchProtocols(
      {required int offset, required int perPage, required String? type, String? category}) async {
    try {
      final response = await _remoteDataSource.fetchProtocols(offset: offset, perPage: perPage, type: type, category: category);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<ProtocolCategoryEntity>>> fetchProtocolCategories() async {
    try {
      final response = await _remoteDataSource.fetchProtocolCategories();

      return Result.success(response.map((item) => item.asEntity()).toList());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ProtocolDetailsEntity>> fetchProtocolDetails(String id, String protocolType) async {
    try {
      final response = await _remoteDataSource.fetchProtocolDetails(id, protocolType);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<CustomizeProtocolEntity>> fetchCustomizeProtocolData(String id) async {
    try {
      final response = await _remoteDataSource.fetchCustomizeProtocolData(id);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<CustomizeProtocolEntity>> saveCustomizeProtocolData(
      String id, CustomizeProtocolEntity customizeProtocolModel, bool isFromBlankTemplate) async {
    try {
      final model = CustomizeProtocolRequestModel(
        protocol: customizeProtocolModel.protocol,
        id: customizeProtocolModel.id,
        title: customizeProtocolModel.title,
        category: customizeProtocolModel.category,
        image: customizeProtocolModel.image,
        isActive: customizeProtocolModel.isActive,
        isTemplate: customizeProtocolModel.isTemplate,
        routines: customizeProtocolModel.routines
            .map((routine) => Routine(
                  id: routine.id,
                  activeDay: routine.activeDay,
                  day: routine.day,
                  items: routine.items
                      .map((item) => RoutineItem(
                            id: item.id,
                            title: item.title,
                            startTime: item.startTime,
                            endTime: item.endTime,
                          ))
                      .toList(),
                ))
            .toList(),
      );
      final response = await _remoteDataSource.saveCustomizeProtocolData(id, model, isFromBlankTemplate);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ProtocolDetailsEntity>> updateProtocolGoal(
      CustomizeProtocolActiveRequestEntity customizeProtocolActiveRequestEntity) async {
    try {
      final model = CustomizeProtocolActiveRequestModel(
          protocolType: customizeProtocolActiveRequestEntity.protocolType,
          protocolId: customizeProtocolActiveRequestEntity.protocolId,
          updateGoals: customizeProtocolActiveRequestEntity.updateGoals,
          activate: customizeProtocolActiveRequestEntity.activate);
      final response = await _remoteDataSource.updateProtocolGoal(model);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> deleteUserProtocol(String id) async {
    try {
      final response = await _remoteDataSource.deleteUserProtocol(id);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
