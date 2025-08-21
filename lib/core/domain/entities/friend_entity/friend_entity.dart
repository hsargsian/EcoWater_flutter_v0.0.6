import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/friend_domain.dart';
import '../user_entity/user_entity.dart';

part 'friend_entity.g.dart';

@JsonSerializable()
class FriendEntity {
  FriendEntity(this.id, this.user);

  factory FriendEntity.fromJson(Map<String, dynamic> json) =>
      _$FriendEntityFromJson(json);

  final String id;
  final UserEntity user;

  Map<String, dynamic> toJson() => _$FriendEntityToJson(this);
  FriendDomain toDomain(UserDomain me) => FriendDomain(this, user.id == me.id);
}
