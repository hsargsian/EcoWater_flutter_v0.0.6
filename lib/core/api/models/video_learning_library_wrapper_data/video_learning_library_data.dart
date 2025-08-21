import 'package:echowater/core/domain/entities/video_learning_library_entity/video_learning_library_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_learning_library_data.g.dart';

@JsonSerializable()
class VideoLearningLibraryData {
  VideoLearningLibraryData(this.id, this.title, this.thumbnail, this.url);

  factory VideoLearningLibraryData.fromJson(Map<String, dynamic> json) =>
      _$VideoLearningLibraryDataFromJson(json);

  final String id;
  final String title;
  final String? thumbnail;
  final String url;

  Map<String, dynamic> toJson() => _$VideoLearningLibraryDataToJson(this);

  VideoLearningLibraryEntity asEntity() =>
      VideoLearningLibraryEntity(id, title, thumbnail, url, false);
}
