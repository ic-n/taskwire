import 'package:flutter/material.dart';

class LoadingLine extends CustomPainter {
  const LoadingLine({
    required this.progress,
  }) : super();

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const start = Offset(20, 20);
    double endX = 20;
    double endY = size.height - 20;

    var progressY = 20 + ((endY - 20) * progress) - 2;

    var paint = Paint();
    paint.color = Colors.white.withAlpha(35);
    paint.strokeWidth = 5;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(start, Offset(endX, endY), paint);

    var end = Offset(endX, progressY);

    paint.color = Colors.white.withAlpha(93);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
