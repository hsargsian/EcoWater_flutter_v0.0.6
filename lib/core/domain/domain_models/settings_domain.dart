import 'package:echowater/core/domain/entities/settings_entity/settings_entity.dart';

class SettingsDomain {
  const SettingsDomain(this._entity);
  final SettingsEntity _entity;

  bool get promotionalEmail => _entity.promotionalEmails;
  bool get accountUpdates => _entity.accountUpdates;
  bool get progressNotifications => _entity.progressNotifications;
  bool get newsNotifications => _entity.newsNotifications;
  bool get bottleNotifications => _entity.bottleNotification;
}
