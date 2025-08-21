import 'package:echowater/core/domain/entities/video_learning_library_entity/video_learning_library_entity.dart';
import 'package:equatable/equatable.dart';

class VideoLearningLibraryDomain extends Equatable {
  const VideoLearningLibraryDomain(this._entity);
  final VideoLearningLibraryEntity _entity;

  String? get thumbnail => _entity.thumbnail;
  String get url => _entity.url;
  String get title => _entity.title;

  bool get isSeeAllView => _entity.isSeeAllView;

  @override
  List<Object?> get props => [_entity.id];
}
