import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    on<StartCounterEvent>(_startCountdown);
    on<TickEvent>(_onTick);
  }

  Timer? _timer;

  void _startCountdown(StartCounterEvent event, Emitter<CounterState> emit) {
    var remainingSeconds = event.totalSeconds;
    add(TickEvent(remainingSeconds));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0) {
        _timer?.cancel();
        add(TickEvent(0));
        return;
      } else {
        remainingSeconds--;
        add(TickEvent(remainingSeconds));
      }
    });
  }

  void _onTick(TickEvent event, Emitter<CounterState> emit) {
    final remainingSeconds = event.remainingSeconds;

    final days = remainingSeconds ~/ (24 * 3600);
    final hours = (remainingSeconds % (24 * 3600)) ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    final seconds = remainingSeconds % 60;

    emit(CounterState(days: days, hours: hours, minutes: minutes, seconds: seconds));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
