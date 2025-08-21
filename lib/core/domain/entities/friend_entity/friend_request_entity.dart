import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/friend_request_domain.dart';

part 'friend_request_entity.g.dart';

@JsonSerializable()
class FriendRequestEntity {
  FriendRequestEntity(this.id, this.user);

  factory FriendRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestEntityFromJson(json);

  final String id;
  final UserEntity user;

  Map<String, dynamic> toJson() => _$FriendRequestEntityToJson(this);
  FriendRequestDomain toDomain() => FriendRequestDomain(this);
}
