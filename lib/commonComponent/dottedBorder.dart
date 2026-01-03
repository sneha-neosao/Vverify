import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  BuildContext context;

  DottedBorderPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Theme.of(context).primaryColorDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const double radius = 8.0; // Set the same radius as in the BoxDecoration

    final RRect rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );

    // Draw the top border with rounded corners
    _drawDashedBorder(canvas, rect, paint);
  }

  void _drawDashedBorder(Canvas canvas, RRect rect, Paint paint) {
    double startX = rect.left;
    double startY = rect.top;
    double endX = rect.right;
    double endY = rect.bottom;

    const double dashWidth = 3.0;
    const double dashSpace = 3.0;

    // Top edge (dashed)
    for (double x = startX; x < endX; x += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x + dashWidth, startY),
        paint,
      );
    }

    // Right edge (dashed)
    for (double y = startY; y < endY; y += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(endX, y),
        Offset(endX, y + dashWidth),
        paint,
      );
    }

    // Bottom edge (dashed)
    for (double x = endX; x > startX; x -= dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(x, endY),
        Offset(x - dashWidth, endY),
        paint,
      );
    }

    // Left edge (dashed)
    for (double y = endY; y > startY; y -= dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX, y - dashWidth),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
