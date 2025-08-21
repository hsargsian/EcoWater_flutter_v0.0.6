import 'dart:io';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/faq_entity/faq_entity.dart';
import '../../domain/entities/system_access_entity/system_access_entity.dart';
import '../../domain/entities/terms_of_service_entity.dart';
import '../../domain/repositories/other_repository.dart';
import '../data_sources/other_data_sources/other_local_datasource.dart';
import '../data_sources/other_data_sources/other_remote_datasource.dart';

class OtherRepositoryImpl implements OtherRepository {
  OtherRepositoryImpl(
      {required OtherRemoteDataSource remoteDataSource,
      required OtherLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final OtherRemoteDataSource _remoteDataSource;
  final OtherLocalDataSource _localDataSource;

  @override
  Future<Result<TermsOfServiceEntity>> fetchTermsOfService() async {
    try {
      final response = await _remoteDataSource.fetchTermsOfService();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<FaqEntity>>> fetchFaqs() async {
    try {
      final response = await _remoteDataSource.fetchFaqs();
      return Result.success(response.map((e) => e.asEntity()).toList());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<SystemAccessEntity>> getSystemAccessState() async {
    try {
      final response = await _remoteDataSource.getSystemAccessState();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<void> addNewLog(
      String? flaskSerialId, bool hasError, File file) async {
    await _remoteDataSource.addNewLog(flaskSerialId, hasError, file);
    return;
  }
}
