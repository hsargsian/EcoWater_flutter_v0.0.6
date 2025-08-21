part of 'counter_bloc.dart';

@immutable
sealed class CounterEvent {}

class StartCounterEvent extends CounterEvent {
  StartCounterEvent({required this.totalSeconds});
  final int totalSeconds;
}

class TickEvent extends CounterEvent {
  TickEvent(this.remainingSeconds);
  final int remainingSeconds;
}
