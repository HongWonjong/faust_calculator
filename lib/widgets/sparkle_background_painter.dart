import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/style.dart';

class SparkleBackgroundPainter extends CustomPainter {
  final double animationValue;

  SparkleBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      final opacity = (animationValue * random.nextDouble()).clamp(0.3, 1.0);

      paint.color = AppStyles.sparkleColors[random.nextInt(AppStyles.sparkleColors.length)]
          .withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SparkleBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}