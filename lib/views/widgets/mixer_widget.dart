import 'package:drone_factory/models/track_model.dart';
import 'package:drone_factory/views/widgets/track_widget.dart';
import 'package:flutter/material.dart';

class MixerWidget extends StatefulWidget {
  const MixerWidget({super.key});

  @override
  State<MixerWidget> createState() => _MixerWidgetState();
}

class _MixerWidgetState extends State<MixerWidget> {
  @override
  Widget build(BuildContext context) {
    final List<TrackModel> tracks = List.generate(
      8,
      (index) => TrackModel(id: index),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return TrackWidget(
              trackModel: tracks[index],
            );
          },
        ),
      ),
    );
  }
}