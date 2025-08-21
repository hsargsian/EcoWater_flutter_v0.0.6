import 'package:echowater/core/api/models/personal_goal_data/personal_goal_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal_goal_wrapper_data.g.dart';

@JsonSerializable()
class PersonalGoalWrapperData {
  PersonalGoalWrapperData(
    this.personalGoals,
  );

  factory PersonalGoalWrapperData.fromJson(Map<String, dynamic> json) =>
      _$PersonalGoalWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<PersonalGoalData> personalGoals;

  Map<String, dynamic> toJson() => _$PersonalGoalWrapperDataToJson(this);
}
