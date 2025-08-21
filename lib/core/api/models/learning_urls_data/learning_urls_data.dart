import 'package:echowater/core/domain/entities/learning_urls_entity/learning_urls_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'learning_urls_data.g.dart';

@JsonSerializable()
class LearningUrlsData {
  LearningUrlsData(this.supportUrl, this.digitalManualUrl);

  factory LearningUrlsData.fromJson(Map<String, dynamic> json) =>
      _$LearningUrlsDataFromJson(json);

  @JsonKey(name: 'support_url')
  final String supportUrl;
  @JsonKey(name: 'digital_manual_url')
  final String digitalManualUrl;

  Map<String, dynamic> toJson() => _$LearningUrlsDataToJson(this);

  LearningUrlsEntity asEntity() =>
      LearningUrlsEntity(supportUrl, digitalManualUrl);
}
