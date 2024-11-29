import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/providers/patch_provider.dart';
import 'package:drone_factory/utils/oscilloscope_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Oscilloscope extends StatefulWidget {
  const Oscilloscope({super.key});

  @override
  State<Oscilloscope> createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope> {
  final NativeSynthesizer _synthesizer = NativeSynthesizer();
  List<double>? _waveformData;

  @override
  void initState() {
    super.initState();
    _listenToVisualizationData();
  }

  void _listenToVisualizationData() {
    _synthesizer.visualizationDataStream.listen((data) {
      setState(() {
        _waveformData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final patchName = context.watch<PatchProvider>().currentPatch.patchName;
    
    return CustomPaint(
      painter: OscilloscopePainter(_waveformData),
      size: Size.infinite,
      child:  Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            patchName,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.amber,
              fontFamily: 'CocomatLight',
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}