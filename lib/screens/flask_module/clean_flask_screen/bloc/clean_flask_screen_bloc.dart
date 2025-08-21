import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/flask_domain.dart';
import '../../../../core/domain/repositories/flask_repository.dart';

part 'clean_flask_screen_event.dart';
part 'clean_flask_screen_state.dart';

class CleanFlaskScreenBloc
    extends Bloc<CleanFlaskScreenEvent, CleanFlaskScreenState> {
  CleanFlaskScreenBloc({required FlaskRepository flaskRepository})
      : _flaskRepository = flaskRepository,
        super(CleanFlaskScreenIdleState()) {
    on<AddFlaskCleanLogEvent>(_onAddFlaskCleanLog);
  }
  final FlaskRepository _flaskRepository;

  Future<void> _onAddFlaskCleanLog(
    AddFlaskCleanLogEvent event,
    Emitter<CleanFlaskScreenState> emit,
  ) async {
    emit(UpdatingCleanFlaskLogState());
    final response = await _flaskRepository.cleanFlask(id: event.flask.id);
    response.when(success: (responeMessage) {
      emit(UpdatedCleanFlaskLogState(responeMessage.message));
    }, error: (errorMessage) {
      emit(CleanFlaskScreenApiErrorState(errorMessage.toMessage()));
    });
  }
}
