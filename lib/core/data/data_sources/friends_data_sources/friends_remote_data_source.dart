import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/empty_success_response/api_success_message_response.dart';
import 'package:echowater/core/api/models/friend_requests_wrapper_data/friend_requests_wrapper_data.dart';
import 'package:echowater/core/api/models/friends_wrapper_data/friends_wrapper_data.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';

abstract class FriendsRemoteDataSource {
  Future<FriendsWrapperData> fetchMyFriends(
      {required String searchString,
      required int offset,
      required int perPage});

  Future<ApiSuccessMessageResponse> sendFriendRequest(
      {required String friendId});

  Future<ApiSuccessMessageResponse> updateFriendRequestAction(
      {required String friendId, required String action});

  Future<FriendRequestsWrapperData> fetchReceivedRequests(
      {required String isIgnored, required int offset, required int perPage});

  Future<FriendRequestsWrapperData> fetchSentRequests(
      {required int offset, required int perPage});
}

class FriendsRemoteDataSourceImpl extends FriendsRemoteDataSource {
  FriendsRemoteDataSourceImpl(
      {required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchFriendsCancelToken = CancelToken();
  CancelToken _sendFriendRequestCancelToken = CancelToken();

  CancelToken _updateFriendRequestActionCancelToken = CancelToken();
  CancelToken _fetchFriendRequestsReceivedCancelToken = CancelToken();
  CancelToken _fetchFriendRequestsSentCancelToken = CancelToken();

  @override
  Future<FriendsWrapperData> fetchMyFriends(
      {required String searchString,
      required int offset,
      required int perPage}) async {
    try {
      _fetchFriendsCancelToken.cancel();
      _fetchFriendsCancelToken = CancelToken();
      return await _authorizedApiClient.fetchFriends(
          searchString.isEmpty ? null : searchString,
          offset,
          perPage,
          _fetchFriendsCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> sendFriendRequest(
      {required String friendId}) async {
    try {
      _sendFriendRequestCancelToken.cancel();
      _sendFriendRequestCancelToken = CancelToken();
      await _authorizedApiClient.sendFriendRequest(
          friendId, _sendFriendRequestCancelToken);
      return Future.value(
          ApiSuccessMessageResponse('Friend Request has been sent'));
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> updateFriendRequestAction(
      {required String friendId, required String action}) async {
    try {
      _updateFriendRequestActionCancelToken.cancel();
      _updateFriendRequestActionCancelToken = CancelToken();
      return await _authorizedApiClient.updateFriendRequestAction(
          friendId, action, _updateFriendRequestActionCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FriendRequestsWrapperData> fetchReceivedRequests(
      {required String isIgnored,
      required int offset,
      required int perPage}) async {
    try {
      _fetchFriendRequestsReceivedCancelToken.cancel();
      _fetchFriendRequestsReceivedCancelToken = CancelToken();
      return await _authorizedApiClient.fetchFriendRequestsReceived(
          isIgnored, offset, perPage, _fetchFriendRequestsReceivedCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FriendRequestsWrapperData> fetchSentRequests(
      {required int offset, required int perPage}) async {
    try {
      _fetchFriendRequestsSentCancelToken.cancel();
      _fetchFriendRequestsSentCancelToken = CancelToken();
      return await _authorizedApiClient.fetchFriendRequestsSent(
          offset, perPage, _fetchFriendRequestsSentCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
