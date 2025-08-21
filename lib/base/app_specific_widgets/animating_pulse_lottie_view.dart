import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatingPulseLottieView extends StatelessWidget {
  const AnimatingPulseLottieView({required this.path, this.text, super.key});
  final String path;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Lottie.asset(path, repeat: true, width: constraints.maxWidth, height: constraints.maxWidth);
              },
            ),
          ),
          Center(
            child: Text(
              text ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}
