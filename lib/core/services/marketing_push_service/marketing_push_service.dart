import '../../domain/entities/user_entity/user_entity.dart';

abstract class MarketingPushService {
  UserEntity? user;
  void setUser(UserEntity user);
  Future<void> initializeWithKey({required String key});
  Future<void> sendTokenToKlaviyo(String token);
  void resetProfile();
  void addProperties(Map<String, dynamic> newProperties);
}
