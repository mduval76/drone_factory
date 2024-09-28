import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';

class MixerWidget extends StatelessWidget {
  const MixerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<TrackModel> tracks = List.generate(
      8,
      (index) => TrackModel(
        id: index,
        volume: 1.0,
        frequency: 440.0,
        wavetable: Wavetable.sine,
      ),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: tracks,
        ),
      ),
      );
  }
}