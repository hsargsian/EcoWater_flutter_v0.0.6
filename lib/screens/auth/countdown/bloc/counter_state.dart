part of 'counter_bloc.dart';

@immutable
class CounterState {
  const CounterState({required this.days, required this.hours, required this.minutes, required this.seconds});

  factory CounterState.initial() {
    return const CounterState(days: 0, hours: 0, minutes: 0, seconds: 0);
  }

  final int days;
  final int hours;
  final int minutes;
  final int seconds;
}
