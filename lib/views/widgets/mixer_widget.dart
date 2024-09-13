import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';

class MixerWidget extends StatelessWidget {
  const MixerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<TrackModel> tracks = [];

    for (int i = 0; i < 8; i++) {
      tracks.add(TrackModel(
        id: i,
        volume: 0.5,
        frequency: 440.0,
        wavetable: Wavetable.sine,
      ));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tracks.map((i) => 
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 4, 192),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${i.id}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ).toList(),
        ),
      )
    );
  }
}