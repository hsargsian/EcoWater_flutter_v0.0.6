import 'package:echowater/core/domain/domain_models/video_learning_library_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/video_learning_library_entity/video_learning_library_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_entity/page_meta_entity.dart';

part 'video_learning_library_wrapper_entity.g.dart';

@JsonSerializable()
class VideoLearningLibraryWrapperEntity {
  VideoLearningLibraryWrapperEntity(
    this.videos,
    this.pageMeta,
  );

  factory VideoLearningLibraryWrapperEntity.fromJson(
          Map<String, dynamic> json) =>
      _$VideoLearningLibraryWrapperEntityFromJson(json);

  final List<VideoLearningLibraryEntity> videos;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() =>
      _$VideoLearningLibraryWrapperEntityToJson(this);
  VideoLearningLibraryWrapperDomain toDomain() =>
      VideoLearningLibraryWrapperDomain(
          pageMeta.hasMore, videos.map((e) => e.toDomain()).toList());
}
