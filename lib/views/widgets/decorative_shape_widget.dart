import 'package:flutter/material.dart';
import 'dart:math' as math;

class DecorativeShapeWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Color shadowColor;
  DecorativeShapeWidget({
    Key? key,
    this.size = 200,
    required this.color,
    required this.shadowColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BlobPainter(
        color: shadowColor,
        radius: size * 0.5,
        center: Offset(size * 0.5, size * 0.5),
        irregularity: 0.3,
        complexity: 3,
      ),
      child: CustomPaint(
        painter: BlobPainter(
          color: color,
          radius: size * 0.4,
          center: Offset(size * 0.5, size * 0.5),
          irregularity: 0.35,
          complexity: 3,
        ),
        child: Container(
          width: size,
          height: size,
        ),
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  final Color color;
  final double radius;
  final Offset center;
  final double irregularity;
  final int complexity;
  BlobPainter({
    required this.color,
    required this.radius,
    required this.center,
    this.irregularity = 0.3,
    this.complexity = 2,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();
    double angleStep = 2 * math.pi / 360;
    for (double angle = 0.0; angle < 2 * math.pi; angle += angleStep) {
      double offset = (irregularity * math.sin(complexity * angle) + 1);
      var x = center.dx + offset * radius * math.cos(angle);
      var y = center.dy + offset * radius * math.sin(angle);
      if (angle == 0.0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}