import 'package:echowater/core/domain/entities/friend_entity/friend_entity.dart';
import 'package:equatable/equatable.dart';

import 'user_domain.dart';

class FriendDomain extends Equatable {
  const FriendDomain(this._entity, this.isMe);
  final FriendEntity _entity;
  final bool isMe;

  UserDomain get user => UserDomain(_entity.user, isMe);

  String? get profileImage => user.primaryImageUrl();
  String get name => user.name;
  String get senderId => user.id;

  @override
  List<Object?> get props => [_entity.id];
}
