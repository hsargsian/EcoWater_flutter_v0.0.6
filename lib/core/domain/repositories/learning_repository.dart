import 'package:echowater/core/domain/entities/video_learning_library_entity/video_learning_library_wrapper_entity.dart';

import '../../api/resource/resource.dart';
import '../entities/article_learning_library_entity/article_learning_library_wrapper_entity.dart';
import '../entities/learning_urls_entity/learning_urls_entity.dart';

abstract class LearningRepository {
  Future<Result<LearningUrlsEntity>> fetchLearningBaseUrls();
  Future<Result<VideoLearningLibraryWrapperEntity>> fetchVideoLibrary(
      {required int offset, required int perPage});
  Future<Result<ArticleLearningLibraryWrapperEntity>> fetchArticlesLibrary(
      {required int offset, required int perPage});
}
