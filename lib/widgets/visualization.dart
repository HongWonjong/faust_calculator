import 'package:flutter/material.dart';

class Map2DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.blueGrey;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), borderPaint);

    final pointPaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RelationshipGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.redAccent;
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20, nodePaint);
    canvas.drawCircle(Offset(size.width / 4, size.height / 4), 15, nodePaint);
    canvas.drawCircle(Offset(3 * size.width / 4, 3 * size.height / 4), 15, nodePaint);

    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(size.width / 4, size.height / 4),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(3 * size.width / 4, 3 * size.height / 4),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}