import 'package:echowater/core/domain/domain_models/video_learning_library_domain.dart';
import 'package:echowater/core/domain/entities/video_learning_library_entity/video_learning_library_entity.dart';

class VideoLearningLibraryWrapperDomain {
  VideoLearningLibraryWrapperDomain(this.hasMore, this.videos);
  bool hasMore;
  List<VideoLearningLibraryDomain> videos;

  void remove({required VideoLearningLibraryDomain video}) {
    videos.remove(video);
  }

  void addSeeMoreIfNecessary() {
    videos.add(VideoLearningLibraryDomain(
        VideoLearningLibraryEntity('-1', '', null, '', true)));
  }
}
