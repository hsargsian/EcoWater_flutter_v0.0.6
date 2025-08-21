import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_request_entity.dart';
import 'package:equatable/equatable.dart';

class FriendRequestDomain extends Equatable {
  const FriendRequestDomain(this._entity);
  final FriendRequestEntity _entity;

  UserDomain get sender => UserDomain(_entity.user, false);

  String? get profileImage => sender.primaryImageUrl();
  String get name => sender.name;
  String get senderId => sender.id;

  @override
  List<Object?> get props => [_entity.id];
}
