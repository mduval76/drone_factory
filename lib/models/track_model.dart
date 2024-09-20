import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackModel extends StatefulWidget {
  final int id;
  final double volume;
  final double frequency;
  final Wavetable wavetable;

  const TrackModel({
    super.key, 
    required this.id,
    required this.volume,
    required this.frequency,
    required this.wavetable,
  });

  @override
  State<TrackModel> createState() => _TrackModelState();
}

class _TrackModelState extends State<TrackModel> {
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

  @override
  void initState() {
    super.initState();
    _volume = widget.volume;
    _frequency = widget.frequency;
    _wavetable = widget.wavetable;
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        title: Text('Track ${widget.id + 1}', style: const TextStyle(color: Colors.white)),
        subtitle: Text('${_wavetable.toString().split('.').last} - ${_frequency.toStringAsFixed(2)} Hz', style: const TextStyle(color: Colors.white)),
        children: [
          const Divider(thickness: 1, color: Colors.grey),
          _buildWavetableSelector(),
          const Divider(thickness: 1, color: Colors.grey),
          _buildFrequencyControl(),
          const Divider(thickness: 1, color: Colors.grey),
          _buildVolumeControl(),
          const Divider(thickness: 1, color: Colors.grey),
        ],
        // onExpansionChanged: (expanded) {
        //   setState(() {
        //     _isExpanded = expanded;
        //   });
        // },
      ),
    );
  }

  Widget _buildWavetableSelector() {
    return SizedBox(
      height: 25,
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
          return Padding(
            padding: const EdgeInsets.only(
              left: 22.5,
            ),
            child: Container(
                decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: wavetable != Wavetable.sawtooth
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
              ),
              child:Transform.scale(
              scale: 6,
              child: IconButton(
                icon: SvgPicture.asset(
                  assetName,
                  height: 25,
                  width: 25,
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
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFrequencyControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Slider(
              min: 20,
              max: 20000,
              value: _frequency,
              onChanged: (value) {
                setState(() {
                  _frequency = value;
                });
                // TODO: Implement frequency change in audio engine
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                border: OutlineInputBorder(),
                labelText: 'Hz',
              ),
              controller: TextEditingController(text: _frequency.toStringAsFixed(2)),
              onSubmitted: (value) {
                double? frequency = double.tryParse(value);
                if (frequency != null && frequency >= 20 && frequency <= 20000) {
                  setState(() {
                    _frequency = frequency;
                  });
                  // TODO: Implement frequency change in audio engine
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              min: 0,
              max: 1,
              value: _volume,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                // TODO: Implement volume change in audio engine
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Wavetable {
  sine,
  triangle,
  square,
  sawtooth,
}