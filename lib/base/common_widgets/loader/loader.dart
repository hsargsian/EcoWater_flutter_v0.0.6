// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

@immutable
class Loader extends StatelessWidget {
  const Loader(
      {super.key, this.color, double strokeWidth = 2.0, double size = 25.0})
      : _strokeWidth = strokeWidth,
        _size = size;
  final Color? color;
  final double _size;
  final double _strokeWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: _strokeWidth,
      ),
    );
  }
}
