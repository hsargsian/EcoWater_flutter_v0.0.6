import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/friend_entity/friend_entity.dart';
import '../user_data/user_data.dart';

part 'friend_data.g.dart';

@JsonSerializable()
class FriendData {
  FriendData(this.id, this.user);

  factory FriendData.fromJson(Map<String, dynamic> json) =>
      _$FriendDataFromJson(json);

  final String id;
  @JsonKey(name: 'friend')
  final UserData user;

  Map<String, dynamic> toJson() => _$FriendDataToJson(this);

  FriendEntity asEntity() => FriendEntity(id, user.asEntity());
}
