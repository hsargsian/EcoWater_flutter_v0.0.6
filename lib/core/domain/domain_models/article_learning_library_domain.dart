import 'package:equatable/equatable.dart';

import '../entities/article_learning_library_entity/article_learning_library_entity.dart';

class ArticleLearningLibraryDomain extends Equatable {
  const ArticleLearningLibraryDomain(this._entity);
  final ArticleLearningLibraryEntity _entity;

  String? get thumbnail => _entity.thumbnail;
  String get title => _entity.title;
  String get url => _entity.url;
  int get order => _entity.order;

  bool get isSeeAllView => _entity.isSeeAllView;

  @override
  List<Object?> get props => [_entity.id];
}
