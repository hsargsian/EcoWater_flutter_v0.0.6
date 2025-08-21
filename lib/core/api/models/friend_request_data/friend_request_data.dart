import 'package:echowater/core/api/models/user_data/user_data.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_request_data.g.dart';

@JsonSerializable()
class FriendRequestData {
  FriendRequestData(this.id, this.user);

  factory FriendRequestData.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestDataFromJson(json);

  final String id;
  final UserData user;

  Map<String, dynamic> toJson() => _$FriendRequestDataToJson(this);

  FriendRequestEntity asEntity() => FriendRequestEntity(id, user.asEntity());
}
