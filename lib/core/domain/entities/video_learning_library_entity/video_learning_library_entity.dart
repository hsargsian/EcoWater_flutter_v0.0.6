import 'package:echowater/core/domain/domain_models/video_learning_library_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_learning_library_entity.g.dart';

@JsonSerializable()
class VideoLearningLibraryEntity {
  VideoLearningLibraryEntity(
      this.id, this.title, this.thumbnail, this.url, this.isSeeAllView);

  factory VideoLearningLibraryEntity.fromJson(Map<String, dynamic> json) =>
      _$VideoLearningLibraryEntityFromJson(json);

  final String id;
  final String title;
  final String? thumbnail;
  final String url;
  final bool isSeeAllView;

  Map<String, dynamic> toJson() => _$VideoLearningLibraryEntityToJson(this);
  VideoLearningLibraryDomain toDomain() => VideoLearningLibraryDomain(this);
}
