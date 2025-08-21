import 'package:echowater/core/domain/domain_models/friend_domain.dart';

class FriendsWrapperDomain {
  FriendsWrapperDomain(this.hasMore, this.friends);
  bool hasMore;
  List<FriendDomain> friends;

  void remove(FriendDomain friend) {
    friends.remove(friend);
  }
}
