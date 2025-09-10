import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/app/constants/app_colors.dart';
import '../../../core/extensions/context_extension.dart';

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.9;
    const dashWidth = 5;
    const dashSpace = 3;

    final rect = Rect.fromCircle(
      center: Offset(size.width, size.height / 2),
      radius: radius,
    );

    const gradient = SweepGradient(
      startAngle: pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        Colors.white,
        AppColors.morning,
      ],
    );

    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    final path = Path()..addArc(rect, pi / 2, pi);

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.5;
      while (distance < pathMetric.length) {
        final segment = pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedCircle extends StatelessWidget {
  const DottedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedCirclePainter(),
      child: SizedBox(
        width: context.width * 0.4,
        height: context.width * 0.4,
      ),
    );
  }
}
