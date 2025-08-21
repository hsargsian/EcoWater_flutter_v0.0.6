import 'package:echowater/core/domain/domain_models/user_domain.dart';

class UsersWrapperDomain {
  UsersWrapperDomain(this.hasMore, this.users);
  bool hasMore;
  List<UserDomain> users;

  void remove({required UserDomain user}) {
    users.remove(user);
  }

  void unfriend(UserDomain user) {
    final index = users.indexOf(user);
    if (index != -1) {
      users[index].unfriend();
    }
  }
}
