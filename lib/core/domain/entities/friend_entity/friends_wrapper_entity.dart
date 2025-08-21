import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/friends_wrapper_domain.dart';
import '../page_meta_entity/page_meta_entity.dart';

part 'friends_wrapper_entity.g.dart';

@JsonSerializable()
class FriendsWrapperEntity {
  FriendsWrapperEntity(
    this.friends,
    this.pageMeta,
  );

  factory FriendsWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$FriendsWrapperEntityFromJson(json);

  final List<FriendEntity> friends;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$FriendsWrapperEntityToJson(this);
  FriendsWrapperDomain toDomain(UserDomain me) => FriendsWrapperDomain(
      pageMeta.hasMore, friends.map((e) => e.toDomain(me)).toList());
}
