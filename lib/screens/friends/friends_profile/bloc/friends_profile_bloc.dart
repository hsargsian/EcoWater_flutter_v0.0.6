import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../core/domain/repositories/friends_repository.dart';

part 'friends_profile_event.dart';

part 'friends_profile_state.dart';

class FriendsProfileBloc
    extends Bloc<FriendsProfileEvent, FriendsProfileState> {
  FriendsProfileBloc(
      {required FriendsRepository friendRepository,
      required UserRepository userRepository})
      : _friendRepository = friendRepository,
        _userRepository = userRepository,
        super(FriendsProfileInitial()) {
    on<InitialEvent>(_onFetchUser);
    on<RequestActionFriendEvent>(_onRequestAction);
    on<SendFriendRequestEvent>(_onSendFriendRequest);
    on<ReportFriendEvent>(_onReport);
  }
  final FriendsRepository _friendRepository;
  final UserRepository _userRepository;
  late UserDomain user;
  bool hasFetchedUserDetails = false;

  FutureOr<void> _onFetchUser(
      InitialEvent event, Emitter<FriendsProfileState> emit) async {
    final response = await _userRepository.fetchProfileInformation(
      userId: event.id,
    );
    response.when(success: (userEntity) {
      hasFetchedUserDetails = true;
      user = UserDomain(userEntity, false);
      emit(FetchUserDataState(user));
    }, error: (error) {
      emit(FriendsProfileMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onSendFriendRequest(
    SendFriendRequestEvent event,
    Emitter<FriendsProfileState> emit,
  ) async {
    final response =
        await _friendRepository.sendFriendRequest(friendId: event.user.id);
    response.when(success: (success) {
      emit(FriendsProfileMessageState(success.message, SnackbarStyle.success));
      // emit(FriendRequestSentState());
      add(InitialEvent(event.user.id));
    }, error: (error) {
      emit(FriendsProfileMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onRequestAction(
    RequestActionFriendEvent event,
    Emitter<FriendsProfileState> emit,
  ) async {
    final response = await _friendRepository.updateFriendRequestAction(
        friendId: event.user.id, action: event.actionName);
    response.when(success: (success) {
      add(InitialEvent(event.user.id));
    }, error: (error) {
      emit(FriendsProfileMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onReport(
    ReportFriendEvent event,
    Emitter<FriendsProfileState> emit,
  ) async {
    final response = await _friendRepository.updateFriendRequestAction(
        friendId: event.user.id, action: 'report');
    response.when(success: (success) {
      emit(FriendsProfileMessageState(success.message, SnackbarStyle.success));
    }, error: (error) {
      emit(FriendsProfileMessageState(error.toMessage(), SnackbarStyle.error));
    });
  }
}
