import 'package:echowater/core/domain/domain_models/personal_goal_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal_goal_entity.g.dart';

@JsonSerializable()
class PersonalGoalEntity {
  PersonalGoalEntity(
    this.id,
    this.bottlePPMType,
    this.totalValue,
    this.completedValue,
    this.isDummy,
  );

  factory PersonalGoalEntity.fromJson(Map<String, dynamic> json) => _$PersonalGoalEntityFromJson(json);

  final String id;
  final String bottlePPMType;
  final int totalValue;
  final num completedValue;
  final bool isDummy;

  Map<String, dynamic> toJson() => _$PersonalGoalEntityToJson(this);

  PersonalGoalDomain toDomain(DateTime date) => PersonalGoalDomain(this, date, '');
}
