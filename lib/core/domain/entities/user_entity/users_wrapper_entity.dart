import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/user_domain.dart';
import '../../domain_models/users_wrapper_domain.dart';
import '../page_meta_entity/page_meta_entity.dart';

part 'users_wrapper_entity.g.dart';

@JsonSerializable()
class UsersWrapperEntity {
  UsersWrapperEntity(
    this.users,
    this.pageMeta,
  );

  factory UsersWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$UsersWrapperEntityFromJson(json);

  final List<UserEntity> users;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$UsersWrapperEntityToJson(this);
  UsersWrapperDomain toDomain(UserDomain me) => UsersWrapperDomain(
      pageMeta.hasMore, users.map((e) => e.toDomain(e.id == me.id)).toList());
}
