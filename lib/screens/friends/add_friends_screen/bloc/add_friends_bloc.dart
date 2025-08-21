import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/fetch_style.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/domain_models/users_wrapper_domain.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/domain/repositories/friends_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'add_friends_event.dart';

part 'add_friends_state.dart';

class AddFriendsBloc extends Bloc<AddFriendsEvent, AddFriendsState> {
  AddFriendsBloc(
      {required FriendsRepository friendsRepository,
      required UserRepository userRepository})
      : _friendsRepository = friendsRepository,
        _userRepository = userRepository,
        super(AddFriendsIdleState()) {
    on<SearchUsersEvent>(_searchUsers);
    on<UnfriendEvent>(_onUnfriend);
  }

  final FriendsRepository _friendsRepository;
  final UserRepository _userRepository;

  UsersWrapperDomain searchResult = UsersWrapperDomain(
    true,
    [],
  );

  Future<void> _onUnfriend(
    UnfriendEvent event,
    Emitter<AddFriendsState> emit,
  ) async {
    final response = await _friendsRepository.updateFriendRequestAction(
      friendId: event.user.id,
      action: 'remove',
    );
    response.when(success: (success) {
      searchResult.unfriend(event.user);
      emit(FetchedSearchResultState());
    }, error: (error) {
      emit(AddFriendMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _searchUsers(
      SearchUsersEvent event, Emitter<AddFriendsState> emit) async {
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
        emit(FetchingSearchResultState());
        searchResult = UsersWrapperDomain(
          true,
          [],
        );
      case FetchStyle.pullToRefresh:
        searchResult = UsersWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = searchResult.users.length;
    }
    final currentUser = await _userRepository.getCurrentUserFromCache();

    if (currentUser == null) {
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      emit(AddFriendMessageState(
          'user_session_expired_message'.localized, SnackbarStyle.error));
      return;
    }
    final response = await _userRepository.search(
        offset: offset,
        perPage: 10,
        searchString: event.searchString,
        isFriendList: false);
    response.when(success: (resultResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          searchResult = resultResponse.toDomain(UserDomain(currentUser, true));
        case FetchStyle.loadMore:
          searchResult.hasMore = resultResponse.pageMeta.hasMore;
          searchResult.users.addAll(resultResponse.users
              .map((e) => e.toDomain(e.id == currentUser.id))
              .toList());
      }
      emit(FetchedSearchResultState());
    }, error: (error) {
      emit(AddFriendMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }
}
