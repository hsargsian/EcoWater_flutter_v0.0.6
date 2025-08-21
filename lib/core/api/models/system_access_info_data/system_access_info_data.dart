import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/system_access_entity/system_access_entity.dart';

part 'system_access_info_data.g.dart';

@JsonSerializable()
class SystemAccessInfoData {
  SystemAccessInfoData(this.canAccessSystem, this.accessDate);

  factory SystemAccessInfoData.fromJson(Map<String, dynamic> json) =>
      _$SystemAccessInfoDataFromJson(json);
  @JsonKey(name: 'can_access')
  final bool canAccessSystem;
  @JsonKey(name: 'access_date')
  final String accessDate;

  Map<String, dynamic> toJson() => _$SystemAccessInfoDataToJson(this);

  SystemAccessEntity asEntity() =>
      SystemAccessEntity(canAccessSystem, accessDate);
}
