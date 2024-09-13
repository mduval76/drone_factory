import 'package:flutter/material.dart';

class TrackModel extends StatefulWidget {
  final int id;
  final double volume;
  final double frequency;
  final Wavetable wavetable;

  const TrackModel({super.key, 
    required this.id,
    required this.volume,
    required this.frequency,
    required this.wavetable,
  });

  @override
  State<TrackModel> createState() => _TrackModelState();
}

class _TrackModelState extends State<TrackModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color.fromARGB(255, 255, 4, 192),
          width: 1,
        ),
      ),
    );
  }
}

enum Wavetable {
  sine,
  triangle,
  square,
  sawtooth,
}