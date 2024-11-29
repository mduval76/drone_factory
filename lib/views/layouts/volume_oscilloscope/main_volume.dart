import 'dart:math';
import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:flutter/material.dart';

class MainVolume extends StatelessWidget {
  final NativeSynthesizer nativeSynthesizer;

  const MainVolume({
    super.key,
    required this.nativeSynthesizer,
  });

  @override
  Widget build(BuildContext context) {
    final double currentWidgetHeight = MediaQuery.of(context).size.height;
    final double maxBarHeight = currentWidgetHeight * 0.333;
    return StreamBuilder<List<double>>(
      stream: nativeSynthesizer.visualizationDataStream,
      builder: (context, snapshot) {
        final List<double> visualizationBuffer = snapshot.data ?? [];
        final double leftChannelLevel = calculateLevelForChannel(visualizationBuffer, channel: 'left');
        final double rightChannelLevel = calculateLevelForChannel(visualizationBuffer, channel: 'right');
        
        return Container(
          height: double.infinity,
          padding: const EdgeInsets.all(2.5),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              right: BorderSide(
                color: Color.fromARGB(255, 255, 4, 192),
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // LEFT CHANNEL
              Container(
                height: max(0, leftChannelLevel * maxBarHeight),
                width: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 1),
              // RIGHT CHANNEL
              Container(
                height: max(0, rightChannelLevel * maxBarHeight),
                width: 15,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  double calculateRMS(List<double> samples) {
    if (samples.isEmpty) return 0.0;
    double sumOfSquares = 0.0;
    for (final sample in samples) {
      sumOfSquares += sample * sample;
    }
    return sqrt(sumOfSquares / samples.length);
  }

  double calculateLevelForChannel(List<double> buffer, {required String channel}) {
    if (buffer.isEmpty) return 0.0;

    List<double> channelSamples = [];
    int startIndex = (channel == 'left') ? 0 : 1;

    for (int i = startIndex; i < buffer.length; i += 2) {
      channelSamples.add(buffer[i]);
    }
    return calculateRMS(channelSamples);
  }
}