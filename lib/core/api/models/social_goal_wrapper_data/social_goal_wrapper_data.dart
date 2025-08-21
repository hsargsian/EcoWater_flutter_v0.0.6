import 'package:echowater/core/api/models/social_goal_data/social_goal_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_goal_wrapper_data.g.dart';

@JsonSerializable()
class SocialGoalWrapperData {
  SocialGoalWrapperData(
    this.socialGoals,
  );

  factory SocialGoalWrapperData.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<SocialGoalData> socialGoals;

  Map<String, dynamic> toJson() => _$SocialGoalWrapperDataToJson(this);
}
