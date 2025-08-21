import 'package:echowater/core/api/resource/resource.dart';
import 'package:echowater/core/data/data_sources/learning_data_sources/learning_local_data_source.dart';
import 'package:echowater/core/data/data_sources/learning_data_sources/learning_remote_data_source.dart';
import 'package:echowater/core/domain/entities/learning_urls_entity/learning_urls_entity.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../domain/entities/article_learning_library_entity/article_learning_library_wrapper_entity.dart';
import '../../domain/entities/video_learning_library_entity/video_learning_library_wrapper_entity.dart';
import '../../domain/repositories/learning_repository.dart';

class LearningRepositoryImpl implements LearningRepository {
  LearningRepositoryImpl(
      {required LearningRemoteDataSource remoteDataSource,
      required LearningLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final LearningRemoteDataSource _remoteDataSource;
  final LearningLocalDataSource _localDataSource;

  @override
  Future<Result<LearningUrlsEntity>> fetchLearningBaseUrls() async {
    try {
      final response = await _remoteDataSource.fetchBaseLearningUrls();

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<VideoLearningLibraryWrapperEntity>> fetchVideoLibrary(
      {required int offset, required int perPage}) async {
    try {
      final response = await _remoteDataSource.fetchVideoLibrary(
          offset: offset, perPage: perPage);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ArticleLearningLibraryWrapperEntity>> fetchArticlesLibrary(
      {required int offset, required int perPage}) async {
    try {
      final response = await _remoteDataSource.fetchArticleLibrary(
          offset: offset, perPage: perPage);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
