import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/views/layouts/volume_oscilloscope/main_volume.dart';
import 'package:drone_factory/views/layouts/volume_oscilloscope/oscilloscope.dart';
import 'package:flutter/material.dart';

class VolumeOscilloscopeLayout extends StatelessWidget {
  final NativeSynthesizer nativeSynthesizer;

  const VolumeOscilloscopeLayout({
    super.key,
    required this.nativeSynthesizer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color.fromARGB(255, 255, 4, 192),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: MainVolume(nativeSynthesizer: nativeSynthesizer)
          ),
          const Expanded(
            flex: 8,
            child: Oscilloscope(),
          )
        ],
      ),
    );
  }
}