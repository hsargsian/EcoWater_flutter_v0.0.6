import 'package:echowater/core/api/models/friend_data/friend_data.dart';
import 'package:echowater/core/domain/entities/friend_entity/friends_wrapper_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_data/page_meta_data.dart';

part 'friends_wrapper_data.g.dart';

@JsonSerializable()
class FriendsWrapperData {
  FriendsWrapperData(this.friends, this.pageMeta);

  factory FriendsWrapperData.fromJson(Map<String, dynamic> json) =>
      _$FriendsWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<FriendData> friends;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  FriendsWrapperEntity asEntity() => FriendsWrapperEntity(
      friends.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
