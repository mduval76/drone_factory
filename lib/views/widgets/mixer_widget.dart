import 'package:drone_factory/models/track_model.dart';
import 'package:drone_factory/views/widgets/track_tab_widget.dart';
import 'package:flutter/material.dart';

class MixerWidget extends StatelessWidget {
  final int selectedTrack;
  final ValueChanged<int> onTrackSelected;
  final Color Function(int) setTrackColor;

  const MixerWidget({
    super.key,
    required this.selectedTrack,
    required this.onTrackSelected,
    required this.setTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<TrackModel> tracks = List.generate(
      8,
      (index) => TrackModel(id: index),
    );

    return Column(
      children: List.generate(tracks.length * 2 - 1, (index) {
        if (index.isEven) {
          int trackIndex = index ~/ 2;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onTrackSelected(trackIndex);
              },
              child: TrackTabWidget(
                trackModel: tracks[trackIndex],
                color: setTrackColor(trackIndex),
                selectedTrackIndex: selectedTrack,
              ),
            ),
          );
        } else {
          return const SizedBox(height: 5.0);
        }
      }),
    );
  }
}