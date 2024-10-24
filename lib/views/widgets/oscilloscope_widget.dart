import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/utils/oscilloscope_painter.dart';
import 'package:flutter/material.dart';

class OscilloscopeWidget extends StatefulWidget {
  const OscilloscopeWidget({super.key});

  @override
  State<OscilloscopeWidget> createState() => _OscilloscopeWidgetState();
}

class _OscilloscopeWidgetState extends State<OscilloscopeWidget> {
  final NativeSynthesizer _synthesizer = NativeSynthesizer();
  List<double>? _waveformData;

  @override
  void initState() {
    super.initState();
    _getVisualizationData();
  }

  Future<void> _getVisualizationData() async {
    while (true) {
      final data = await _synthesizer.getVisualizationData();
      setState(() {
        _waveformData = data;
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OscilloscopePainter(_waveformData),
      size: Size.infinite,
    );
  }
}