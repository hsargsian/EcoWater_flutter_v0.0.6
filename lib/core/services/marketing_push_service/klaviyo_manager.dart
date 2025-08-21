import 'dart:async';

import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:klaviyo_flutter/klaviyo_flutter.dart';

import 'marketing_push_service.dart';

class KlaviyoMarketingPushService implements MarketingPushService {
  @override
  UserEntity? user;

  Map<String, dynamic> _properties = {};

  @override
  Future<void> initializeWithKey({required String key}) async {
    await Klaviyo.instance.initialize(key);
  }

  @override
  void setUser(UserEntity user) {
    this.user = user;
    unawaited(Klaviyo.instance.setEmail(user.email));
    _syncProperties(user.toJson());
    unawaited(Klaviyo.instance.updateProfile(user.klaviyoProfile(_properties)));
  }

  void _syncProperties(Map<String, dynamic> newProperties) {
    _properties.addAll(newProperties);
  }

  @override
  Future<void> sendTokenToKlaviyo(String token) async {
    await Klaviyo.instance.sendTokenToKlaviyo(token);
  }

  @override
  void resetProfile() {
    _properties = {};
    unawaited(Klaviyo.instance.resetProfile());
  }

  @override
  void addProperties(Map<String, dynamic> newProperties) {
    if (user == null) {
      return;
    }
    _syncProperties(newProperties);
    unawaited(
        Klaviyo.instance.updateProfile(user!.klaviyoProfile(_properties)));
  }
}
