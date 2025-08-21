import 'package:echowater/core/api/resource/resource.dart';
import 'package:echowater/core/data/data_sources/friends_data_sources/friends_local_data_source.dart';
import 'package:echowater/core/data/data_sources/friends_data_sources/friends_remote_data_source.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/friend_entity/friend_requests_wrapper_entity.dart';
import 'package:echowater/core/domain/entities/friend_entity/friends_wrapper_entity.dart';
import 'package:echowater/core/domain/repositories/friends_repository.dart';

import '../../api/exceptions/custom_exception.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  FriendsRepositoryImpl(
      {required FriendsRemoteDataSource remoteDataSource,
      required FriendsLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final FriendsRemoteDataSource _remoteDataSource;
  final FriendsLocalDataSource _localDataSource;

  @override
  Future<Result<FriendsWrapperEntity>> fetchMyFriends(
      {required String searchString,
      required int offset,
      required int perPage}) async {
    try {
      final friendsResponse = await _remoteDataSource.fetchMyFriends(
          searchString: searchString, offset: offset, perPage: perPage);

      return Result.success(friendsResponse.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> sendFriendRequest(
      {required String friendId}) async {
    try {
      final response =
          await _remoteDataSource.sendFriendRequest(friendId: friendId);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> updateFriendRequestAction(
      {required String friendId, required String action}) async {
    try {
      final response = await _remoteDataSource.updateFriendRequestAction(
          friendId: friendId, action: action);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FriendRequestsWrapperEntity>> fetchFriendRequestsReceived(
      {required String isIgnored,
      required int offset,
      required int perPage}) async {
    try {
      final response = await _remoteDataSource.fetchReceivedRequests(
          isIgnored: isIgnored, offset: offset, perPage: perPage);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FriendRequestsWrapperEntity>> fetchFriendRequestsSent(
      {required int offset, required int perPage}) async {
    try {
      final response = await _remoteDataSource.fetchSentRequests(
          offset: offset, perPage: perPage);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
