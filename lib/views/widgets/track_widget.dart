import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackWidget extends StatefulWidget {
  final TrackModel trackModel;

  const TrackWidget({super.key, required this.trackModel});

  @override
  State<TrackWidget> createState() => _TrackModelState();
}

class _TrackModelState extends State<TrackWidget> {
  final NativeSynthesizer _synthesizer = NativeSynthesizer(); 
  late double _volume;
  late double _frequency;
  late Wavetable _wavetable;
  //bool _isExpanded = false;

  void _changeWavetable(int wavetable) async {
    await _synthesizer.setWavetable(_wavetable.index);

    setState(() {
      _wavetable = Wavetable.values[wavetable];
    });
  }

  void _setFrequency(double frequency) async {
    await _synthesizer.setFrequency(frequency);
  }

    void _setVolume(double volume) async {
    await _synthesizer.setVolume(volume);
  }

  @override
  void initState() {
    super.initState();
    _volume = widget.trackModel.volume;
    _frequency = widget.trackModel.frequency;
    _wavetable = widget.trackModel.wavetable;
  }

  @override
Widget build(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(
        color: const Color.fromARGB(255, 255, 4, 192),
        width: 1,
      ),
    ),
    child: ExpansionTileTheme(
      data: const ExpansionTileThemeData(
        iconColor: Colors.white,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        collapsedIconColor: Colors.grey,
        collapsedTextColor: Colors.white,
        collapsedBackgroundColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
      child: ExpansionTile(
          title: Text(
            '${widget.trackModel.id + 1}',
            style: const TextStyle(
              fontSize: 20, // Reduce font size
            ),
          ),
          children: [
            const Divider(thickness: 1, color: Colors.grey),
            _buildWavetableSelector(),
            const Divider(thickness: 1, color: Colors.grey),
            _buildFrequencyControl(),
            const Divider(thickness: 1, color: Colors.grey),
            _buildVolumeControl(),
            const SizedBox(height: 7.5),
          ],
        ),
      ),
    );
}

  Widget _buildWavetableSelector() {
    return SizedBox(
      height: 22.5,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          }
          return Container(
              padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: wavetable != Wavetable.sawtooth
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
              ),
              child: Transform.scale(
                scale: 7,
                child: IconButton(
                  icon: SvgPicture.asset(
                    assetName,
                    height: 20,
                    width: 20,
                    color: _wavetable == wavetable ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _wavetable = wavetable;
                      _changeWavetable(wavetable.index);
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
                data: const SliderThemeData(
                  trackHeight: 25,
                  activeTrackColor: Color.fromARGB(227, 255, 255, 255),
                  inactiveTrackColor: Color.fromARGB(196, 158, 158, 158),
                  thumbColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.5),
                  trackShape: RectangularSliderTrackShape(),
                ),
                child: Slider(
                  min: 20,
                  max: 2000,
                  value: _frequency,
                  onChanged: (value) {
                    setState(() {
                      _frequency = value;
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
              data: const SliderThemeData(
                trackHeight: 25,
                activeTrackColor: Color.fromARGB(227, 255, 255, 255),
                inactiveTrackColor: Color.fromARGB(196, 158, 158, 158),
                thumbColor: Colors.white,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.5),
                trackShape: RectangularSliderTrackShape(),
              ),
              child: Slider(
                min: 0,
                max: 1,
                value: _volume,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
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