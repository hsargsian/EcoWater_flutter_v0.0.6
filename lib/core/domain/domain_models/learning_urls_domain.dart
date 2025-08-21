import 'package:echowater/core/domain/entities/learning_urls_entity/learning_urls_entity.dart';
import 'package:equatable/equatable.dart';

class LearningUrlsDomain extends Equatable {
  const LearningUrlsDomain(this._entity);
  final LearningUrlsEntity _entity;

  @override
  List<Object?> get props => [_entity.supportUrl, _entity.digitalManualUrl];

  String get supportUrl => _entity.supportUrl;
  String get digitalManualUrl => _entity.digitalManualUrl;
}
