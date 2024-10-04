import 'package:drone_factory/models/track_model.dart';
import 'package:drone_factory/views/widgets/mixer_widget.dart';
import 'package:drone_factory/views/widgets/track_controls_widget.dart';
import 'package:flutter/material.dart';

class MainMixerTrackControlsSection extends StatefulWidget {
  const MainMixerTrackControlsSection({super.key});

  @override
  State<MainMixerTrackControlsSection> createState() => _MainMixerTrackControlsSectionState();
}

class _MainMixerTrackControlsSectionState extends State<MainMixerTrackControlsSection> {
  late List<TrackModel> _tracks;
  late TrackModel _selectedTrack;

  @override
  void initState() {
    super.initState();
    _tracks = List.generate(8, (index) => TrackModel(trackId: index));
    _selectedTrack = _tracks[0];
  }

  void _updateSelectedTrack(int trackId) {
    setState(() {
      _selectedTrack = _tracks[trackId];
    });
  }

  Color _setTrackColor(int trackId) {
    switch (trackId) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      case 4:
        return Colors.blueAccent;
      case 5:
        return Colors.indigo;
      case 6:
        return Colors.purple;
      case 7:
        return Colors.pinkAccent;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = _setTrackColor(_selectedTrack.trackId);

    return Row(
      children: <Widget>[
        Expanded(
          child: MixerWidget(
            selectedTrack: _selectedTrack.trackId,
            onTrackSelected: _updateSelectedTrack,
            setTrackColor: _setTrackColor,
          ),
        ),
        Expanded(
          flex: 9,
          child: TrackControlsWidget(
            selectedTrack: _selectedTrack,
            borderColor: selectedColor,
          ),
        ),
      ],
    );
  }
}