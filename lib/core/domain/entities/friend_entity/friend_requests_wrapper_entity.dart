import 'package:echowater/core/domain/domain_models/friend_request_wrapper_domain.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../page_meta_entity/page_meta_entity.dart';

part 'friend_requests_wrapper_entity.g.dart';

@JsonSerializable()
class FriendRequestsWrapperEntity {
  FriendRequestsWrapperEntity(
    this.friendRequests,
    this.pageMeta,
  );

  factory FriendRequestsWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestsWrapperEntityFromJson(json);

  final List<FriendRequestEntity> friendRequests;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$FriendRequestsWrapperEntityToJson(this);
  FriendRequestsWrapperDomain toDomain() => FriendRequestsWrapperDomain(
      pageMeta.hasMore, friendRequests.map((e) => e.toDomain()).toList());
}
