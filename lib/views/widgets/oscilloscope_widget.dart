import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/utils/oscilloscope_painter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Timer? _timer;

class OscilloscopeWidget extends StatefulWidget {
  const OscilloscopeWidget({super.key});

  @override
  State<OscilloscopeWidget> createState() => _OscilloscopeWidgetState();
}

class _OscilloscopeWidgetState extends State<OscilloscopeWidget> {
  List<double> visualizationSamples = List.generate(100, (_) => 0.0);
  late StreamSubscription<List<double>> _subscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _startListening() {
    _subscription = NativeSynthesizer().getOscilloscopeSamplesStream().listen((samples) {
      setState(() {
        visualizationSamples = samples;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OscilloscopePainter(visualizationSamples),
      size: const Size(double.infinity, 200),
    );
  }
}