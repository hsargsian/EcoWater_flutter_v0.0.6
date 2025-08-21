import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_wrapper_domain.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/domain/repositories/flask_repository.dart';

part 'led_color_selector_event.dart';
part 'led_color_selector_state.dart';

class LedColorSelectorBloc
    extends Bloc<LedColorSelectorEvent, LedColorSelectorState> {
  LedColorSelectorBloc({required FlaskRepository flaskRepository})
      : _flaskRepository = flaskRepository,
        super(LedColorSelectorIdleState()) {
    on<FetchAllColorsEvent>(_onFetchAllColorsEvent);
  }
  final FlaskRepository _flaskRepository;

  List<LedLightColorWrapperDomain> ledColors = <LedLightColorWrapperDomain>[];

  Future<void> _onFetchAllColorsEvent(
    FetchAllColorsEvent event,
    Emitter<LedColorSelectorState> emit,
  ) async {
    emit(FetchingLedColorsState());
    final response = await _flaskRepository.fetchLedColors();
    response.when(success: (colors) {
      ledColors = colors.map(LedLightColorWrapperDomain.new).toList();
      emit(FetchedLedColorsState());
    }, error: (error) {
      emit(LedColorSelectorApiErrorState(error.toMessage()));
    });
  }
}
