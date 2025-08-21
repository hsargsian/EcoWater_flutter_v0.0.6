import 'package:flutter/material.dart';

class CounterText extends ImplicitlyAnimatedWidget {
  const CounterText({
    required super.duration,
    required this.value,
    this.style,
    super.key,
  });
  final int value;
  final TextStyle? style;

  @override
  ImplicitlyAnimatedWidgetState<CounterText> createState() =>
      _CounterTextState();
}

class _CounterTextState extends AnimatedWidgetBaseState<CounterText> {
  late IntTween? _counter;

  @override
  void initState() {
    _counter = IntTween(begin: widget.value, end: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_counter?.evaluate(animation) ?? ''}',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _counter = visitor(
      _counter,
      widget.value,
      (dynamic value) => IntTween(begin: value),
    )! as IntTween;
  }
}
