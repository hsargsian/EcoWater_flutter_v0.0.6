import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/learning_urls_data/learning_urls_data.dart';
import 'package:echowater/core/api/models/video_learning_library_wrapper_data/video_learning_library_wrapper_data.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/article_learning_library_wrapper_data/article_learning_library_wrapper_data.dart';

abstract class LearningRemoteDataSource {
  Future<LearningUrlsData> fetchBaseLearningUrls();
  Future<VideoLearningLibraryWrapperData> fetchVideoLibrary(
      {required int offset, required int perPage});
  Future<ArticleLearningLibraryWrapperData> fetchArticleLibrary(
      {required int offset, required int perPage});
}

class LearningRemoteDataSourceImpl extends LearningRemoteDataSource {
  LearningRemoteDataSourceImpl(
      {required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchLearningUrlsCancelToken = CancelToken();
  CancelToken _fetchVideoLibraryCancelToken = CancelToken();
  CancelToken _fetchArticleLibraryCancelToken = CancelToken();

  @override
  Future<LearningUrlsData> fetchBaseLearningUrls() async {
    try {
      _fetchLearningUrlsCancelToken.cancel();
      _fetchLearningUrlsCancelToken = CancelToken();
      return await _authorizedApiClient.fetchBaseLearningUrls();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<VideoLearningLibraryWrapperData> fetchVideoLibrary(
      {required int offset, required int perPage}) async {
    try {
      _fetchVideoLibraryCancelToken.cancel();
      _fetchVideoLibraryCancelToken = CancelToken();
      return await _authorizedApiClient.fetchVideoLibrary(offset, perPage);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ArticleLearningLibraryWrapperData> fetchArticleLibrary(
      {required int offset, required int perPage}) async {
    try {
      _fetchArticleLibraryCancelToken.cancel();
      _fetchArticleLibraryCancelToken = CancelToken();
      return await _authorizedApiClient.fetchArticleLibrary(offset, perPage);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
