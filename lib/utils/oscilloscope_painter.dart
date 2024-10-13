import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class OscilloscopePainter extends CustomPainter {
  final List<double> visualizationSamples;

  OscilloscopePainter(this.visualizationSamples);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    const int interpolationFactor = 5;

    for (int i = 0; i < visualizationSamples.length - 1; i++) {
      // Original points
      final double x1 = i * (size.width / visualizationSamples.length);
      final double y1 = midY - (visualizationSamples[i] * midY);
      final double x2 = (i + 1) * (size.width / visualizationSamples.length);
      final double y2 = midY - (visualizationSamples[i + 1] * midY);

      for (int j = 0; j < interpolationFactor; j++) {
        final double t = j / interpolationFactor;
        final double x = x1 + (x2 - x1) * t;
        final double y = y1 + (y2 - y1) * t;
        if (j == 0) {
          canvas.drawCircle(Offset(x, y), 1.0, paint);
        } else {
          final double prevX = x1 + ((x2 - x1) * ((j - 1) / interpolationFactor));
          final double prevY = y1 + ((y2 - y1) * ((j - 1) / interpolationFactor));
          canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(OscilloscopePainter oldDelegate) {
    return oldDelegate.visualizationSamples != visualizationSamples;
  }
}