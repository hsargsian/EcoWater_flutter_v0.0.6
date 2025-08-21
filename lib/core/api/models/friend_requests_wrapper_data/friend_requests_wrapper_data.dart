import 'package:echowater/core/api/models/friend_request_data/friend_request_data.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_requests_wrapper_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_data/page_meta_data.dart';

part 'friend_requests_wrapper_data.g.dart';

@JsonSerializable()
class FriendRequestsWrapperData {
  FriendRequestsWrapperData(this.friendRequests, this.pageMeta);

  factory FriendRequestsWrapperData.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestsWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<FriendRequestData> friendRequests;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  FriendRequestsWrapperEntity asEntity() => FriendRequestsWrapperEntity(
      friendRequests.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
