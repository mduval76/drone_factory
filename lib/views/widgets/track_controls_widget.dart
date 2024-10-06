import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          Center(
            child:Text(
              'Track ${widget.selectedTrack.trackId + 1}',
              style: TextStyle(
                color: widget.borderColor,
                fontSize: 20,
                fontFamily: 'QuicksandRegular',
                fontWeight: FontWeight.bold
              )
            ), 
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
          _buildWavetableSelector(),
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
          _buildFrequencyControl(),
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
          _buildVolumeControl(),
          const Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildWavetableSelector() {
    return SizedBox(
      height: 22.5,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: Wavetable.values.map((wavetable) {
          String assetName;
          switch (wavetable) {
            case Wavetable.sine:
              assetName = 'assets/icons/sine.svg';
              break;
            case Wavetable.triangle:
              assetName = 'assets/icons/triangle.svg';
              break;
            case Wavetable.square:
              assetName = 'assets/icons/square.svg';
              break;
            case Wavetable.sawtooth:
              assetName = 'assets/icons/sawtooth.svg';
              break;
            case Wavetable.none:
              assetName = 'assets/icons/none.svg';
              break;
          }
          return Container(
                decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: wavetable != Wavetable.none
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
              ),
              child: Transform.scale(
                scale: 3,
                child: IconButton(
                  icon: SvgPicture.asset(
                    assetName,
                    color: _wavetable == wavetable ? widget.borderColor : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _wavetable = wavetable;
                      widget.selectedTrack.wavetable = wavetable;
                      widget.selectedTrack.isActive = wavetable != Wavetable.none;
                      _setWavetable(wavetable.index);
                    });
                  },
                ),
              ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFrequencyControl() {
    return SizedBox(
      height: 22.5,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Freq:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
              )
            ),
            Expanded(
              flex: 10,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 25,
                  activeTrackColor: widget.borderColor,
                  inactiveTrackColor: const Color.fromARGB(196, 158, 158, 158),
                  thumbColor: widget.borderColor,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.5),
                  trackShape: const RectangularSliderTrackShape(),
                ),
                child: Slider(
                  min: 20,
                  max: 2000,
                  value: _frequency,
                  onChanged: (value) {
                    setState(() {
                      _frequency = value;
                      widget.selectedTrack.frequency = value;
                      _setFrequency(_frequency);
                    });
                  },
                ),
              )
            ),
          ]
        )
      );
  }

  Widget _buildVolumeControl() {
    return SizedBox(
      height: 22.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.0
              ),
              child: Text(
                'Vol:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                ),
              ),
            )
          ),
          Expanded(
            flex: 10,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 25,
                activeTrackColor: widget.borderColor,
                inactiveTrackColor: const Color.fromARGB(196, 158, 158, 158),
                thumbColor: widget.borderColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.5),
                trackShape: const RectangularSliderTrackShape(),
              ),
              child: Slider(
                min: 0,
                max: 1,
                value: _volume,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                    widget.selectedTrack.volume = value;
                    _setVolume(_volume);
                  });
                },
              ),
            )
          ),
        ],
      )
    );
  }
}