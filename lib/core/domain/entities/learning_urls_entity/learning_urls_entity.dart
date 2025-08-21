import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/learning_urls_domain.dart';

part 'learning_urls_entity.g.dart';

@JsonSerializable()
class LearningUrlsEntity {
  LearningUrlsEntity(
    this.supportUrl,
    this.digitalManualUrl,
  );

  factory LearningUrlsEntity.fromJson(Map<String, dynamic> json) =>
      _$LearningUrlsEntityFromJson(json);

  final String supportUrl;
  final String digitalManualUrl;

  Map<String, dynamic> toJson() => _$LearningUrlsEntityToJson(this);
  LearningUrlsDomain toDomain() => LearningUrlsDomain(this);
}
