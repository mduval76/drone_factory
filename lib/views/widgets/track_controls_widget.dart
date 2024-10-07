import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/track_model.dart';
import 'package:drone_factory/views/widgets/track_frequency_control_widget.dart';
import 'package:drone_factory/views/widgets/track_volume_control_widget.dart';
import 'package:drone_factory/views/widgets/track_wavetable_selector_widget.dart';
import 'package:flutter/material.dart';

class TrackControlsWidget extends StatefulWidget {
  final TrackModel selectedTrack;
  final Color borderColor;

  const TrackControlsWidget({
    super.key, 
    required this.selectedTrack, 
    required this.borderColor
  });

  @override
  State<TrackControlsWidget> createState() => _TrackControlsWidgetState();
}

class _TrackControlsWidgetState extends State<TrackControlsWidget> {
  final NativeSynthesizer _synthesizer = NativeSynthesizer(); 
  late double _volume;
  late double _frequency;
  late Wavetable _wavetable;

  void _setWavetable(int wavetable) async {
    await _synthesizer.setWavetable(widget.selectedTrack.trackId, _wavetable.index);

    setState(() {
      _wavetable = Wavetable.values[wavetable];
    });
  }

  void _setIsMuted(bool isMuted) async {
    await _synthesizer.setIsMuted(widget.selectedTrack.trackId, isMuted);

    setState(() {
      widget.selectedTrack.isMuted = isMuted;
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

  void _setFrequency(double frequency) async {
    await _synthesizer.setFrequency(widget.selectedTrack.trackId, frequency);
  }

  void _setVolume(double volume) async {
    await _synthesizer.setVolume(widget.selectedTrack.trackId, volume);
  }

  @override
  void initState() {
    super.initState();
    _volume = widget.selectedTrack.volume;
    _frequency = widget.selectedTrack.frequency;
    _wavetable = widget.selectedTrack.wavetable;
  }

  @override
  void didUpdateWidget(covariant TrackControlsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTrack != widget.selectedTrack) {
      setState(() {
        _volume = widget.selectedTrack.volume;
        _frequency = widget.selectedTrack.frequency;
        _wavetable = widget.selectedTrack.wavetable;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
              Text(
                'Track ${widget.selectedTrack.trackId + 1}',
                style: TextStyle(
                  color: widget.borderColor,
                  fontSize: 20,
                  fontFamily: 'QuicksandRegular',
                  fontWeight: FontWeight.bold
                )
              ),
              OutlinedButtonTheme(
                data: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: widget.selectedTrack.isMuted ? widget.borderColor : Colors.transparent,
                    side: BorderSide(color: widget.borderColor, width: 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    ),
                    minimumSize: const Size(20, 20),
                    padding: EdgeInsets.zero,
                  ),
                ),
                child: OutlinedButton(
                  onPressed:() {
                    if (widget.selectedTrack.isActive) {
                      widget.selectedTrack.isMuted = !widget.selectedTrack.isMuted;
                      _setIsMuted(widget.selectedTrack.isMuted);
                    }
                  }, 
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: widget.selectedTrack.isMuted ? Colors.black : widget.borderColor,
                      fontSize: 15,
                      fontFamily: 'QuicksandRegular',
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Wavetable: ${_getWavetableString(_wavetable)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackWavetableSelectorWidget(
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
                  _setIsMuted(false);
                }
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Frequency: ${_frequency.toStringAsFixed(3)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackFrequencyControlWidget(
            frequency: _frequency,
            borderColor: widget.borderColor,
            onFrequencyChanged: (value) {
              setState(() {
                _frequency = value;
                widget.selectedTrack.frequency = value;
                _setFrequency(_frequency);
              });
            },
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Text(
            'Volume: ${_volume.toStringAsFixed(3)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'QuicksandRegular',
              fontWeight: FontWeight.bold
            )
          ),
          const Divider(thickness: 1, color: Colors.grey),
          TrackVolumeControlWidget(
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
        ],
      ),
    );
  }
}