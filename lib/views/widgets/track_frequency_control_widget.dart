import 'package:flutter/material.dart';

class TrackFrequencyControlWidget extends StatelessWidget {
  final double frequency;
  final double minFrequency;
  final double maxFrequency;
  final Color borderColor;
  final ValueChanged<double> onFrequencyChanged;

  const TrackFrequencyControlWidget({
    super.key,
    required this.frequency,
    this.minFrequency = 20.0,
    this.maxFrequency = 2000.0,
    required this.borderColor,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
          Expanded(
            flex: 10,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 25,
                activeTrackColor: borderColor,
                inactiveTrackColor: const Color.fromARGB(196, 158, 158, 158),
                thumbColor: borderColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.5),
                trackShape: const RectangularSliderTrackShape(),
              ),
              child: Slider(
                min: minFrequency,
                max: maxFrequency,
                value: frequency,
                onChanged: onFrequencyChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}