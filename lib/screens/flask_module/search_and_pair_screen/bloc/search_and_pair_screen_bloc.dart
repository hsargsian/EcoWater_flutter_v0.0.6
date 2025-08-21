import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/oc_libraries/ble_service/app_ble_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/flask_domain.dart';
import '../../../../core/domain/repositories/flask_repository.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'search_and_pair_screen_event.dart';
part 'search_and_pair_screen_state.dart';

class SearchAndPairScreenBloc
    extends Bloc<SearchAndPairScreenEvent, SearchAndPairScreenState> {
  SearchAndPairScreenBloc({
    required FlaskRepository flaskRepository,
    required UserRepository userRepository,
  })  : _flaskRepository = flaskRepository,
        _userRepository = userRepository,
        super(SearchAndPairScreenIdleState()) {
    on<AddNewFlaskEvent>(_onAddNewFlask);
    on<SetFlaskToPairEvent>(_onSetFlaskToPairEvent);
  }
  final FlaskRepository _flaskRepository;
  final UserRepository _userRepository;
  late AppBleModel ble;
  UserDomain? currentUser;
  String deviceName = '';

  Future<void> _onSetFlaskToPairEvent(
    SetFlaskToPairEvent event,
    Emitter<SearchAndPairScreenState> emit,
  ) async {
    ble = event.appBleModel;
    deviceName = event.name;
  }

  Future<void> _onAddNewFlask(
    AddNewFlaskEvent event,
    Emitter<SearchAndPairScreenState> emit,
  ) async {
    final userResponse = await _userRepository.getCurrentUserFromCache();
    if (userResponse == null) {
      emit(SearchAndPairScreenApiErrorState(
          'user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    currentUser = UserDomain(userResponse, true);
    if (deviceName.isEmpty) {
      emit(SearchAndPairScreenApiErrorState(
          'SearchAndPairScreen_provideDeviceName'.localized));
      return;
    }
    emit(AddingNewFlaskState());
    final response = await _flaskRepository.addNewFlask(
        identifier: ble.aliasIdentifier, name: deviceName);
    response.when(success: (flaskEntity) {
      emit(AddedNewFlaskState(FlaskDomain(flaskEntity)));
    }, error: (error) {
      emit(SearchAndPairScreenApiErrorState(error.toMessage()));
    });
  }
}
