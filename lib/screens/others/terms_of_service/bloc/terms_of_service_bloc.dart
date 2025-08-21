import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/repositories/other_repository.dart';

part 'terms_of_service_event.dart';
part 'terms_of_service_state.dart';

class TermsOfServiceBloc
    extends Bloc<TermsOfServiceEvent, TermsOfServiceState> {
  TermsOfServiceBloc({required OtherRepository otherRepository})
      : _otherRepository = otherRepository,
        super(TermsOfServiceIdleState()) {
    on<FetchTermsOfServiceEvent>(_onFetchTermsOfService);
  }
  final OtherRepository _otherRepository;

  Future<void> _onFetchTermsOfService(
    FetchTermsOfServiceEvent event,
    Emitter<TermsOfServiceState> emit,
  ) async {
    emit(TermsOfServiceFetchingState());
    final response = await _otherRepository.fetchTermsOfService();
    response.when(success: (response) {
      emit(TermsOfServiceFetchedState(content: response.content));
    }, error: (error) {
      emit(TermsOfServiceApiErrorState(error.toMessage()));
    });
  }
}
