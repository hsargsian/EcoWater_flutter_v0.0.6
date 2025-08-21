import 'package:echowater/core/api/models/page_meta_data/page_meta_data.dart';
import 'package:echowater/core/domain/entities/user_entity/users_wrapper_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_data/user_data.dart';

part 'user_data_wrapper.g.dart';

@JsonSerializable()
class UserDataWrapper {
  UserDataWrapper(this.users, this.page);

  factory UserDataWrapper.fromJson(Map<String, dynamic> json) =>
      _$UserDataWrapperFromJson(json);
  @JsonKey(name: 'results')
  final List<UserData> users;
  @JsonKey(name: 'meta')
  final PageMetaData page;

  UsersWrapperEntity asEntity() => UsersWrapperEntity(
      users.map((item) => item.asEntity()).toList(), page.asEntity());
}
