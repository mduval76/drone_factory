import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/views/layouts/mixer_controls/mixer_tabs.dart';
import 'package:flutter/material.dart';

class Mixer extends StatelessWidget {
  final int selectedTrack;
  final List<Track> tracks;
  final ValueChanged<int> onTrackSelected;
  final Color Function(int) setTrackColor;
  final Function(int, bool) onMuteChanged;
  final Function(int, bool) onSoloChanged;
  final Function(int) onSelectTrackChanged;

  const Mixer({
    super.key,
    required this.tracks,
    required this.selectedTrack,
    required this.onTrackSelected,
    required this.setTrackColor,
    required this.onMuteChanged,
    required this.onSoloChanged,
    required this.onSelectTrackChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(tracks.length * 2 - 1, (index) {
        if (index.isEven) {
          int trackIndex = index ~/ 2;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onTrackSelected(trackIndex);
              },
              child: MixerTabs(
                currentTrack: tracks[trackIndex],
                color: setTrackColor(trackIndex),
                selectedTrackIndex: selectedTrack,
                onMuteChanged: onMuteChanged,
                onSoloChanged: onSoloChanged,
                onSelectTrackChanged: onSelectTrackChanged,
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