import 'package:echowater/base/utils/strings.dart';

import 'friend_request_domain.dart';

class FriendRequestsWrapperDomain {
  FriendRequestsWrapperDomain(this.hasMore, this.requests);
  bool hasMore;
  List<FriendRequestDomain> requests;

  void remove(FriendRequestDomain request) {
    requests.remove(request);
  }

  String notificationRequestsTitle({bool withSurname = false}) {
    if (requests.isEmpty) {
      return '';
    }
    if (requests.length > 1) {
      final items = [
        withSurname
            ? requests.first.sender.name
            : requests.first.sender.firstName,
        'and'.localized,
        requests.length - 1,
        'others'.localized
      ];
      return items.join(' ');
    }
    return withSurname
        ? requests.first.sender.name
        : requests.first.sender.firstName;
  }

  List<String> get overlappingNotificationImages => requests.isEmpty
      ? []
      : requests
          .sublist(0, requests.length >= 3 ? 3 : requests.length)
          .map((item) => item.sender.primaryImageUrl() ?? '')
          .where((test) => test.isNotEmpty)
          .toList();
}
