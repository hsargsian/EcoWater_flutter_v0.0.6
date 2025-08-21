import 'dart:math';

import 'package:flutter/material.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  const GradientCircularProgressIndicator({
    required this.radius,
    required this.gradientColors,
    required this.value,
    super.key,
    this.strokeWidth = 10.0,
  });

  final double radius;
  final List<Color> gradientColors;
  final double value;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
        value: value,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
    required this.value,
  });

  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final offset = strokeWidth / 2;
    final rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (value == 0.0) {
      paint.color = Colors.black;
      canvas.drawArc(rect, -pi / 2, 2 * pi, false, paint);
    } else if (value < 1.0) {
      final progressAngle = 2 * pi * value;

      paint.shader = SweepGradient(
        colors: gradientColors,
        endAngle: progressAngle,
      ).createShader(rect);
      canvas.drawArc(rect, -pi / 2, progressAngle, false, paint);

      paint
        ..shader = null
        ..color = Colors.black;
      canvas.drawArc(
          rect, -pi / 2 + progressAngle, 2 * pi - progressAngle, false, paint);
    } else {
      paint.shader = SweepGradient(
        colors: gradientColors,
      ).createShader(rect);
      canvas.drawArc(rect, -pi / 2, 2 * pi, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
