import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/faq_domain.dart';
import '../../../../core/domain/repositories/other_repository.dart';

part 'help_screen_event.dart';
part 'help_screen_state.dart';

class HelpScreenBloc extends Bloc<HelpScreenEvent, HelpScreenState> {
  HelpScreenBloc({required OtherRepository otherRepository})
      : _otherRepository = otherRepository,
        super(HelpScreenIdleState()) {
    on<FetchFaqsEvent>(_onFetchFaqs);
  }
  final OtherRepository _otherRepository;
  List<FaqDomain> faqs = <FaqDomain>[];

  Future<void> _onFetchFaqs(
    FetchFaqsEvent event,
    Emitter<HelpScreenState> emit,
  ) async {
    emit(HelpScreenFetchingFaqsState());
    final response = await _otherRepository.fetchFaqs();
    response.when(success: (response) {
      faqs = response.map(FaqDomain.new).toList();
      emit(HelpScreenFetchedFaqsState());
    }, error: (error) {
      emit(HelpScreenApiErrorState(error.toMessage()));
    });
  }
}
