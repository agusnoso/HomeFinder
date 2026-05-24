import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF5F6F8),
            Color(0xFFECEEF1),
          ],
          stops: [0, 0.55, 1],
        ),
      ),
      child: CustomPaint(
        painter: _GeometricBackgroundPainter(),
        child: child,
      ),
    );
  }
}

class _GeometricBackgroundPainter extends CustomPainter {
  const _GeometricBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()..style = PaintingStyle.fill;

    void drawPolygon(List<Offset> points, Color color) {
      final Path path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      overlayPaint.color = color;
      canvas.drawPath(path, overlayPaint);
    }

    drawPolygon([
      Offset(0, 0),
      Offset(size.width * 0.48, 0),
      Offset(size.width * 0.21, size.height * 0.3),
      Offset(0, size.height * 0.2),
    ], const Color(0x12AA1212));

    drawPolygon([
      Offset(size.width * 0.7, 0),
      Offset(size.width, 0),
      Offset(size.width, size.height * 0.33),
      Offset(size.width * 0.52, size.height * 0.22),
    ], const Color(0x0F1F2933));

    drawPolygon([
      Offset(0, size.height * 0.42),
      Offset(size.width * 0.34, size.height * 0.3),
      Offset(size.width * 0.45, size.height * 0.64),
      Offset(size.width * 0.08, size.height * 0.76),
    ], const Color(0x122E3742));

    drawPolygon([
      Offset(size.width * 0.56, size.height * 0.56),
      Offset(size.width, size.height * 0.44),
      Offset(size.width, size.height * 0.78),
      Offset(size.width * 0.66, size.height * 0.9),
    ], const Color(0x14C62828));

    drawPolygon([
      Offset(0, size.height * 0.84),
      Offset(size.width * 0.28, size.height * 0.68),
      Offset(size.width * 0.48, size.height),
      Offset(0, size.height),
    ], const Color(0x12242D38));

    overlayPaint
      ..color = const Color(0x10FFFFFF)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    final Path linePath = Path();
    const int lineCount = 7;
    for (int i = 0; i < lineCount; i++) {
      final double yFactor = (i + 1) / (lineCount + 1);
      linePath.moveTo(0, size.height * (yFactor - 0.2));
      linePath.lineTo(size.width, size.height * (yFactor + 0.2));
    }
    canvas.drawPath(linePath, overlayPaint);

    overlayPaint
      ..style = PaintingStyle.fill
      ..color = const Color(0x0D000000);

    for (int i = 0; i < 3; i++) {
      final double radius = size.shortestSide * (0.22 - (i * 0.045));
      final Offset center = Offset(
        size.width * (0.85 - i * 0.18),
        size.height * (0.14 + i * 0.16),
      );
      canvas.drawCircle(center, math.max(radius, 16), overlayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
