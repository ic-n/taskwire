import 'package:flutter/material.dart';

class LoadingLine extends CustomPainter {
  const LoadingLine({
    this.debug = false,
    required this.progress,
  }) : super();

  final bool debug;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (debug) {
      var dp = Paint();
      dp.color = Colors.red;
      dp.strokeWidth = 5;
      dp.strokeCap = StrokeCap.round;
      canvas.drawLine(Offset.zero, Offset(size.width, size.height), dp);
    }

    const start = Offset(20, 34);
    double endX = 20;
    double endY = size.height + 6;

    var progressY = start.dy + ((endY - start.dy) * progress) - 2;

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
  bool shouldRepaint(CustomPainter oldDelegate) => progress <= 1;
}
