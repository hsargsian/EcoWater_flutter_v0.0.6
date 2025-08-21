import 'package:echowater/core/domain/entities/settings_entity/settings_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_data.g.dart';

@JsonSerializable()
class SettingsData {
  SettingsData(
      this.promotionalEmails,
      this.accountUpdates,
      this.progressNotifications,
      this.newsNotifications,
      this.bottleNotification);

  factory SettingsData.fromJson(Map<String, dynamic> json) =>
      _$SettingsDataFromJson(json);

  @JsonKey(name: 'promotional_emails')
  final bool promotionalEmails;
  @JsonKey(name: 'account_updates')
  final bool accountUpdates;
  @JsonKey(name: 'progress_notifications')
  final bool progressNotifications;
  @JsonKey(name: 'news_notifications')
  final bool newsNotifications;
  @JsonKey(name: 'bottle_notifications')
  final bool bottleNotification;

  Map<String, dynamic> toJson() => _$SettingsDataToJson(this);

  SettingsEntity asEntity() => SettingsEntity(promotionalEmails, accountUpdates,
      progressNotifications, newsNotifications, bottleNotification);
}
