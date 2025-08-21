import 'dart:async';

import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

import '../common_widgets/buttons/normal_button_text.dart';
import '../utils/pair.dart';

class TimerButton extends StatefulWidget {
  const TimerButton({required this.onClick, super.key});
  final Function onClick;

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  late ValueNotifier<Pair> counter;
  late Pair _pair;
  int secondsRemaining = 30;
  bool enableResend = true;
  Timer? timer;

  @override
  void initState() {
    _pair = Pair(first: secondsRemaining, second: enableResend);
    counter = ValueNotifier<Pair>(_pair);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: counter,
        builder: (context, value, _) {
          return NormalTextButton(
            title: enableResend
                ? 'ResetPassword_resend'.localized
                : 'After $secondsRemaining Seconds',
            textColor: Theme.of(context).colorScheme.primary,
            onClick: () {
              if (enableResend) {
                secondsRemaining = 30;
                _timerStart();
                widget.onClick.call();
              }
            },
          );
        });
  }

  void _timerStart() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 1) {
        enableResend = false;
        counter.value = Pair(first: secondsRemaining--, second: enableResend);
      } else {
        if (!enableResend) {
          counter.value = Pair(first: secondsRemaining, second: enableResend);
        }

        enableResend = true;
      }
    });
  }

  @override
  void dispose() {
    _counterDispose();
    super.dispose();
  }

  void _counterDispose() {
    timer?.cancel();
    counter.dispose();
  }
}
