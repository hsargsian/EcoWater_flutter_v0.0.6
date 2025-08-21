import 'package:echowater/core/domain/entities/personal_goal_entity/personal_goal_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal_goal_data.g.dart';

@JsonSerializable()
class PersonalGoalData {
  PersonalGoalData(this.id, this.bottlePPMType, this.totalValue, this.completedValue);

  factory PersonalGoalData.fromJson(Map<String, dynamic> json) => _$PersonalGoalDataFromJson(json);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'goal_type')
  final String bottlePPMType;
  @JsonKey(name: 'goal_number')
  final int totalValue;
  @JsonKey(name: 'goal_completion')
  final num completedValue;

  Map<String, dynamic> toJson() => _$PersonalGoalDataToJson(this);

  PersonalGoalEntity asEntity() => PersonalGoalEntity(id.toString(), bottlePPMType, totalValue, completedValue, false);
}
