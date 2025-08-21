import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/friend_request_domain.dart';
import 'package:echowater/core/domain/domain_models/friend_request_wrapper_domain.dart';
import 'package:echowater/core/domain/repositories/friends_repository.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/domain/domain_models/fetch_style.dart';

part 'friend_request_listing_view_event.dart';
part 'friend_request_listing_view_state.dart';

class FriendRequestsListingViewBloc
    extends Bloc<FriendRequestListingViewEvent, FriendRequestListingViewState> {
  FriendRequestsListingViewBloc({required FriendsRepository friendsRepository})
      : _friendsRepository = friendsRepository,
        super(FriendRequestsListingViewIdleState()) {
    on<FetchFriendRequestsEvent>(_onFetchFriendRequests);
    on<SetFriendRequestListingType>(_onSetFriendRequestsListingType);
    on<AcceptDeclineRequestEvent>(_onAcceptDeclineRequest);
  }
  final FriendsRepository _friendsRepository;

  bool isSubsectionView = false;

  FriendRequestsWrapperDomain friendRequestWrapper =
      FriendRequestsWrapperDomain(
    true,
    [],
  );

  Future<void> _onSetFriendRequestsListingType(
    SetFriendRequestListingType event,
    Emitter<FriendRequestListingViewState> emit,
  ) async {
    isSubsectionView = event.isSubSectionView;
  }

  Future<void> _onAcceptDeclineRequest(
    AcceptDeclineRequestEvent event,
    Emitter<FriendRequestListingViewState> emit,
  ) async {
    final response = await _friendsRepository.updateFriendRequestAction(
        friendId: event.request.senderId,
        action: event.isAccept ? 'accept' : 'reject');
    response.when(success: (success) {
      friendRequestWrapper.remove(event.request);
      emit(FriendRequestStatusChangedState());
    }, error: (error) {
      emit(FriendRequestListingViewApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchFriendRequests(
    FetchFriendRequestsEvent event,
    Emitter<FriendRequestListingViewState> emit,
  ) async {
    emit(FetchingFriendRequestsListingState());
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
      case FetchStyle.pullToRefresh:
        friendRequestWrapper = FriendRequestsWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = friendRequestWrapper.requests.length;
    }

    final response = await _friendsRepository.fetchFriendRequestsReceived(
        isIgnored: '0', offset: offset, perPage: 10);
    response.when(success: (requestsResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          friendRequestWrapper = requestsResponse.toDomain();
        case FetchStyle.loadMore:
          friendRequestWrapper.hasMore = requestsResponse.pageMeta.hasMore;
          friendRequestWrapper.requests.addAll(requestsResponse.friendRequests
              .map((e) => e.toDomain())
              .toList());
      }
      emit(FetchedFriendRequestsListingState());
    }, error: (error) {
      emit(FriendRequestListingViewApiErrorState(error.toMessage()));
    });
  }
}
