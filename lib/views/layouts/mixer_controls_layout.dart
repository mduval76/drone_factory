import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/providers/track_provider.dart';
import 'package:drone_factory/views/layouts/mixer_controls/mixer.dart';
import 'package:drone_factory/views/layouts/track_controls_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MixerControlsLayout extends StatefulWidget {
  const MixerControlsLayout({super.key});

  @override
  State<MixerControlsLayout> createState() => _MixerControlsLayoutState();
}

class _MixerControlsLayoutState extends State<MixerControlsLayout> {
  late Track _selectedTrack;

  @override
  void initState() {
    super.initState();
    final tracks = Provider.of<TrackProvider>(context, listen: false).tracks;
    _selectedTrack = tracks.isNotEmpty ? tracks[0] : Track(trackId: 0);
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

  void _updateSelectedTrack(int trackId) {
    setState(() {
      _selectedTrack = Provider.of<TrackProvider>(context, listen: false).tracks[trackId];
    });
  }

  void _handleMuteChanged(int trackId, bool isMuted) {
    Provider.of<TrackProvider>(context, listen: false).updateTrackMute(trackId, isMuted);
  }

  void _handleSoloChanged(int trackId, bool isSoloed) {
    Provider.of<TrackProvider>(context, listen: false).updateTrackSolo(trackId, isSoloed);
  }

  @override
  Widget build(BuildContext context) {
    final tracks = Provider.of<TrackProvider>(context).tracks;
    final Color selectedColor = _setTrackColor(_selectedTrack.trackId);

    return Row(
      children: <Widget>[
        Expanded(
          child: Mixer(
            tracks: tracks,
            selectedTrack: _selectedTrack.trackId,
            onTrackSelected: _updateSelectedTrack,
            setTrackColor: _setTrackColor,
            onMuteChanged: _handleMuteChanged,
            onSoloChanged: _handleSoloChanged,
            onSelectTrackChanged: _updateSelectedTrack,
          ),
        ),
        Expanded(
          flex: 5,
          child: TrackControlsLayout(
            selectedTrack: _selectedTrack,
            borderColor: selectedColor,
            onMuteChanged: _handleMuteChanged,
            onSoloChanged: _handleSoloChanged,
          ),
        ),
      ],
    );
  }
}