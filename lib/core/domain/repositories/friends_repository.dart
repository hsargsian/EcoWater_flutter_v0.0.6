import 'package:echowater/core/api/resource/resource.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_requests_wrapper_entity.dart';
import 'package:echowater/core/domain/entities/friend_entity/friends_wrapper_entity.dart';

abstract class FriendsRepository {
  Future<Result<FriendsWrapperEntity>> fetchMyFriends(
      {required String searchString,
      required int offset,
      required int perPage});

  Future<Result<ApiSuccessMessageResponseEntity>> sendFriendRequest(
      {required String friendId});

  Future<Result<ApiSuccessMessageResponseEntity>> updateFriendRequestAction(
      {required String friendId, required String action});

  Future<Result<FriendRequestsWrapperEntity>> fetchFriendRequestsReceived(
      {required String isIgnored, required int offset, required int perPage});

  Future<Result<FriendRequestsWrapperEntity>> fetchFriendRequestsSent(
      {required int offset, required int perPage});
}
