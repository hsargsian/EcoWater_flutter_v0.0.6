import 'package:echowater/core/api/models/video_learning_library_wrapper_data/video_learning_library_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/video_learning_library_entity/video_learning_library_wrapper_entity.dart';
import '../page_meta_data/page_meta_data.dart';

part 'video_learning_library_wrapper_data.g.dart';

@JsonSerializable()
class VideoLearningLibraryWrapperData {
  VideoLearningLibraryWrapperData(this.videos, this.pageMeta);

  VideoLearningLibraryWrapperData.getDummyItems()
      : videos = List.generate(
            5,
            (index) => VideoLearningLibraryData(
                index.toString(), 'This is video $index', null, '')),
        pageMeta = PageMetaData(true);

  factory VideoLearningLibraryWrapperData.fromJson(Map<String, dynamic> json) =>
      _$VideoLearningLibraryWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<VideoLearningLibraryData> videos;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  VideoLearningLibraryWrapperEntity asEntity() =>
      VideoLearningLibraryWrapperEntity(
          videos.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
