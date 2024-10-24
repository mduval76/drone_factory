import 'package:flutter/material.dart';

class OscilloscopePainter extends CustomPainter {
  final List<double>? waveformData;

  OscilloscopePainter(this.waveformData);

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData == null || waveformData!.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height / 2;
    final width = size.width;
    final height = size.height;

    final pointCount = waveformData!.length;
    final pixelsPerDataPoint = width / pointCount;

    // Move to starting point
    path.moveTo(0, midY - (waveformData![0] * midY));

    // Draw line between points
    for (int i = 1; i < pointCount; i++) {
      final x1 = (i - 1) * pixelsPerDataPoint;
      final x2 = i * pixelsPerDataPoint;

      final y1 = midY - (waveformData![i - 1] * midY);
      final y2 = midY - (waveformData![i] * midY);

      // Make connections between points smoother
      final midX = (x1 + x2) / 2;
      final midYCurve = (y1 + y2) / 2;
      path.quadraticBezierTo(x1, y1, midX, midYCurve);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(OscilloscopePainter oldDelegate) {
    return true;
    // return oldDelegate.waveformData != waveformData;
  }
}
