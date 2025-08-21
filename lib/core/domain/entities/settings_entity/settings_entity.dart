import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/settings_domain.dart';

part 'settings_entity.g.dart';

@JsonSerializable()
class SettingsEntity {
  SettingsEntity(
      this.promotionalEmails,
      this.accountUpdates,
      this.progressNotifications,
      this.newsNotifications,
      this.bottleNotification);

  factory SettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingsEntityFromJson(json);

  bool promotionalEmails;
  bool accountUpdates;
  bool progressNotifications;
  bool newsNotifications;
  bool bottleNotification;

  Map<String, dynamic> toJson() => _$SettingsEntityToJson(this);
  SettingsDomain toDomain() => SettingsDomain(this);
}
