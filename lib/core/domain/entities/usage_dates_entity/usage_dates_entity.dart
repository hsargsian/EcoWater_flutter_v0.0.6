import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/usage_dates_domain.dart';

part 'usage_dates_entity.g.dart';

@JsonSerializable()
class UsageDatesEntity {
  UsageDatesEntity(this.usageDates);

  factory UsageDatesEntity.fromJson(Map<String, dynamic> json) =>
      _$UsageDatesEntityFromJson(json);

  List<String> usageDates;

  Map<String, dynamic> toJson() => _$UsageDatesEntityToJson(this);
  UsageDatesDomain toDomain() => UsageDatesDomain(this);
}
