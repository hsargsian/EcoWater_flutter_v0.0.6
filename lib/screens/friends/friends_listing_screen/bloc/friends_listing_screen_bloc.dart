import 'package:bloc/bloc.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/repositories/friends_repository.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/domain/domain_models/fetch_style.dart';
import '../../../../core/domain/domain_models/friend_domain.dart';
import '../../../../core/domain/domain_models/friends_wrapper_domain.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'friends_listing_screen_event.dart';
part 'friends_listing_screen_state.dart';

class FriendsListingScreenBloc
    extends Bloc<FriendsListingScreenEvent, FriendsListingScreenState> {
  FriendsListingScreenBloc(
      {required FriendsRepository friendRepository,
      required UserRepository userRepository})
      : _friendRepository = friendRepository,
        _userRepository = userRepository,
        super(FriendsListingScreenIdleState()) {
    on<FetchFriendListEvent>(_onFetchFriends);
    on<UnfriendEvent>(_onUnfriend);
  }
  final FriendsRepository _friendRepository;
  final UserRepository _userRepository;

  UserDomain? user;
  FriendsWrapperDomain friendsWrapper = FriendsWrapperDomain(
    true,
    [],
  );

  Future<void> _onUnfriend(
    UnfriendEvent event,
    Emitter<FriendsListingScreenState> emit,
  ) async {
    final response = await _friendRepository.updateFriendRequestAction(
      friendId: event.friend.senderId,
      action: 'remove',
    );
    response.when(success: (success) {
      friendsWrapper.remove(event.friend);
      emit(FetchedFriendsState());
    }, error: (error) {
      emit(FriendsListingScreenMessageState(
          error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onFetchFriends(
    FetchFriendListEvent event,
    Emitter<FriendsListingScreenState> emit,
  ) async {
    if (user == null) {
      final userEntity = await _userRepository.getCurrentUserFromCache();
      if (userEntity == null) {
        Injector.instance<AuthenticationBloc>().add(
            ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
        emit(FriendsListingScreenMessageState(
            'user_session_expired_message', SnackbarStyle.error));
        return;
      }
      user = UserDomain(userEntity, true);
    }

    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
        emit(FetchingFriendsState());
        friendsWrapper = FriendsWrapperDomain(
          true,
          [],
        );
      case FetchStyle.pullToRefresh:
        friendsWrapper = FriendsWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = friendsWrapper.friends.length;
    }

    final response = await _friendRepository.fetchMyFriends(
        searchString: event.searchString, offset: offset, perPage: 10);
    response.when(success: (friendsResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          friendsWrapper = friendsResponse.toDomain(user!);
        case FetchStyle.loadMore:
          friendsWrapper.hasMore = friendsResponse.pageMeta.hasMore;
          friendsWrapper.friends.addAll(
              friendsResponse.friends.map((e) => e.toDomain(user!)).toList());
      }
      emit(FetchedFriendsState());
    }, error: (error) {
      emit(FriendsListingScreenMessageState(
          error.toMessage(), SnackbarStyle.error));
    });
  }
}
