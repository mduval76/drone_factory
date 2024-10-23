import 'package:flutter/material.dart';

class OscilloscopePainter extends CustomPainter {
  final List<double>? waveformData;

  OscilloscopePainter(this.waveformData);

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData == null || waveformData!.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height / 2;

    // Move to the start of the waveform
    path.moveTo(0, midY);

    // Scale the waveform data to fit the canvas
    final width = size.width;
    final height = size.height;

    for (int i = 0; i < waveformData!.length; i++) {
      final x = (i / waveformData!.length) * width;
      final y = midY - (waveformData![i] * midY); // Scale to fit in height
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(OscilloscopePainter oldDelegate) {
    return oldDelegate.waveformData != waveformData;
  }
}
