import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/providers/track_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MixerTabs extends StatefulWidget {
  final Track currentTrack;
  final Color color;
  final int selectedTrackIndex;
  final Function(int, bool) onMuteChanged;
  final Function(int, bool) onSoloChanged;
  final Function(int) onSelectTrackChanged;

  const MixerTabs({
    super.key, 
    required this.currentTrack, 
    required this.color, 
    required this.selectedTrackIndex,
    required this.onMuteChanged,
    required this.onSoloChanged,
    required this.onSelectTrackChanged,
  });

  @override
  State<MixerTabs> createState() => _MixerTabsState();
}

class _MixerTabsState extends State<MixerTabs> {
  late Color _color;

  NativeSynthesizer get _synthesizer => Provider.of<TrackProvider>(context, listen: false).synthesizer;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  void _setIsMuted(bool isMuted) async {
    await _synthesizer.setIsMuted(widget.currentTrack.trackId, isMuted);

    setState(() {
      widget.currentTrack.isMuted = isMuted;
    });

    widget.onMuteChanged(widget.currentTrack.trackId, isMuted);
  }

  void _setIsSoloed(bool isSoloed) async {
    await _synthesizer.setIsSoloed(widget.currentTrack.trackId, isSoloed);

    setState(() {
      widget.currentTrack.isSoloed = isSoloed;
    });

    widget.onSoloChanged(widget.currentTrack.trackId, isSoloed);
  }
  
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.currentTrack.trackId == widget.selectedTrackIndex;
    bool isActive = widget.currentTrack.wavetable != Wavetable.none;
  
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? _color : isActive ? _color.withOpacity(0.66) : Colors.black,
              border: isSelected ? 
              Border(
              left: BorderSide(
                color: _color,
                width: 2,
              ),
              top: BorderSide(
                color: _color,
                width: 2,
              ),
              bottom: BorderSide(
                color: _color,
                width: 2,
              ),
              right: BorderSide.none,
            ) :
            Border.all(
              color: _color,
              width: 2,
            ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.currentTrack.trackId + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        // MUTE //////////////////////////////////////////////////////////////////////////////
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: OutlinedButtonTheme(
                  data: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.currentTrack.isMuted ? Colors.grey : Colors.black,
                      side: BorderSide(color: _color, width: 2),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      ),
                    ),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.currentTrack.isActive) {
                        widget.currentTrack.isMuted = !widget.currentTrack.isMuted;
                        widget.onSelectTrackChanged(widget.currentTrack.trackId);
                        _setIsMuted(widget.currentTrack.isMuted);
                        
                        setState(() {
                          widget.currentTrack.isMuted = !widget.currentTrack.isMuted;
                        });
                      }
                    },
                    child: Text(
                      'M',
                      style: TextStyle(
                        color: widget.currentTrack.isMuted ? Colors.black : _color,
                        fontSize: 15.0,
                        fontFamily: 'QuicksandRegular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // MUTE //////////////////////////////////////////////////////////////////////////////
              Expanded(
                child: OutlinedButtonTheme(
                  data: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.currentTrack.isSoloed ? Colors.white : Colors.black,
                      side: BorderSide(color: _color, width: 2),
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      ),
                    ),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.currentTrack.isActive) {
                        widget.currentTrack.isSoloed = !widget.currentTrack.isSoloed;
                        widget.onSelectTrackChanged(widget.currentTrack.trackId);
                        _setIsSoloed(widget.currentTrack.isSoloed);
                        
                        setState(() {
                          widget.currentTrack.isSoloed = !widget.currentTrack.isSoloed;
                        });
                      }
                    },
                    child: Text(
                      'S',
                      style: TextStyle(
                        color: widget.currentTrack.isSoloed ? Colors.black : _color,
                        fontSize: 15.0,
                        fontFamily: 'QuicksandRegular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 5.0,
          decoration: BoxDecoration(
            color: isSelected ? _color : Colors.black,
            border: isSelected ? 
              Border(
                left: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
                top: BorderSide(
                  color: _color,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: _color,
                  width: 2,
                ),
              ) :
              Border.all(
                color: Colors.black,
                width: 2,
              ), 
          ),
        ),
      ],
    );
  }
}