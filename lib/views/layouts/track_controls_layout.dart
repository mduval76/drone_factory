import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/providers/base_frequency_provider.dart';
import 'package:drone_factory/providers/track_provider.dart';
import 'package:drone_factory/utils/knob.dart';
import 'package:drone_factory/views/layouts/track_controls/track_frequency.dart';
import 'package:drone_factory/views/layouts/track_controls/track_volume.dart';
import 'package:drone_factory/views/layouts/track_controls/track_wavetable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


class TrackControlsLayout extends StatefulWidget {
  final Track selectedTrack;
  final Color borderColor;
  final Function(int, bool) onMuteChanged;
  final Function(int, bool) onSoloChanged;

  const TrackControlsLayout({
    super.key,
    required this.selectedTrack, 
    required this.borderColor,
    required this.onMuteChanged,
    required this.onSoloChanged,
  });

  @override
  State<TrackControlsLayout> createState() => _TrackControlsLayoutState();
}

class _TrackControlsLayoutState extends State<TrackControlsLayout> {
  late double _volume;
  late double _frequencyOffset;
  late Wavetable _wavetable;

  NativeSynthesizer get _synthesizer => Provider.of<TrackProvider>(context, listen: false).synthesizer;

  @override
  void initState() {
    super.initState();
    _volume = widget.selectedTrack.volume;
    _frequencyOffset = widget.selectedTrack.frequencyOffset;
    _wavetable = widget.selectedTrack.wavetable;
  }


  void _setFrequency(double frequencyOffset) async {
    final baseFrequency = Provider.of<BaseFrequencyProvider>(context, listen: false).baseFrequency;
    double absoluteFrequency = baseFrequency + frequencyOffset;
    absoluteFrequency = absoluteFrequency.clamp(10.0, 1000.0);

    await _synthesizer.setFrequency(widget.selectedTrack.trackId, absoluteFrequency);
  }

  void _setVolume(double volume) async {
    await _synthesizer.setVolume(widget.selectedTrack.trackId, volume);
  }

  void _setWavetable(int wavetable) async {
    await _synthesizer.setWavetable(widget.selectedTrack.trackId, _wavetable.index);

    setState(() {
      _wavetable = Wavetable.values[wavetable];
    });
  }

  String _getWavetableString(Wavetable wavetable) {
    switch (wavetable) {
      case Wavetable.sine:
        return 'SINE';
      case Wavetable.triangle:
        return 'TRIANGLE';
      case Wavetable.square:
        return 'SQUARE';
      case Wavetable.sawtooth:
        return 'SAWTOOTH';
      case Wavetable.none:
        return 'NONE';
    }
  }

  @override
  void didUpdateWidget(covariant TrackControlsLayout oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedTrack != widget.selectedTrack) {
      setState(() {
        _volume = widget.selectedTrack.volume;
        _frequencyOffset = widget.selectedTrack.frequencyOffset;

        final baseFrequency = Provider.of<BaseFrequencyProvider>(context, listen: false).baseFrequency;
        double absoluteFrequency = baseFrequency + _frequencyOffset;

        if (absoluteFrequency < 10.0) {
          _frequencyOffset = 10.0 - baseFrequency;
          widget.selectedTrack.frequencyOffset = _frequencyOffset;
        } 
        else if (absoluteFrequency > 1000.0) {
          _frequencyOffset = 1000.0 - baseFrequency;
          widget.selectedTrack.frequencyOffset = _frequencyOffset;
        }

        _wavetable = widget.selectedTrack.wavetable;

        _setFrequency(_frequencyOffset);
        _setVolume(_volume);
        _setWavetable(_wavetable.index);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final baseFrequency = Provider.of<BaseFrequencyProvider>(context).baseFrequency;

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: widget.borderColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                child: Text(
                  'Track ${widget.selectedTrack.trackId + 1}',
                  style: TextStyle(
                    color: widget.borderColor,
                    fontSize: 20,
                    fontFamily: 'QuicksandRegular',
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Wavetable: ${_getWavetableString(_wavetable)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackWavetable(
            selectedWavetable: _wavetable,
            borderColor: widget.borderColor,
            onWavetableSelected: (wavetableIndex) {
              setState(() {
                _wavetable = Wavetable.values[wavetableIndex];
                widget.selectedTrack.wavetable = _wavetable;
                widget.selectedTrack.isActive = _wavetable != Wavetable.none;
                _setWavetable(wavetableIndex);

                if (widget.selectedTrack.wavetable == Wavetable.none) {
                  widget.selectedTrack.isMuted = false;
                }
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Frequency: ${(baseFrequency + _frequencyOffset).toStringAsFixed(3)} Hz',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackFrequency(
            frequencyOffset: _frequencyOffset,
            baseFrequency: baseFrequency,
            borderColor: widget.borderColor,
            onFrequencyOffsetChanged: (value) {
              setState(() {
                _frequencyOffset = value;
                widget.selectedTrack.frequencyOffset = value;
                _setFrequency(_frequencyOffset);
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Volume: ${_volume.toStringAsFixed(3)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackVolume(
            volume: _volume,
            borderColor: widget.borderColor,
            onVolumeChanged: (value) {
              setState(() {
                _volume = value;
                widget.selectedTrack.volume = value;
                _setVolume(_volume);
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Knob(
            startAngle: math.pi, 
            minAngle: (0.9 * math.pi / 6), 
            maxAngle: (10.9 * math.pi / 6),
            minRange: -1.0,
            maxRange: 1.0,
            borderColor: widget.borderColor
          ),
        ],
      ),
    );
  }
}