import 'package:flutter/material.dart';
import 'dart:math';

class TrackFrequency extends StatelessWidget {
  final double frequencyOffset;
  final double baseFrequency;
  final Color borderColor;
  final ValueChanged<double> onFrequencyOffsetChanged;

  const TrackFrequency({
    super.key,
    required this.frequencyOffset,
    required this.baseFrequency,
    required this.borderColor,
    required this.onFrequencyOffsetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final minFrequencyOffset = 10.0 - baseFrequency;
    final maxFrequencyOffset = 1000.0 - baseFrequency;
    
    double minOffset = min(minFrequencyOffset, maxFrequencyOffset);
    double maxOffset = max(minFrequencyOffset, maxFrequencyOffset);

    if (minOffset > maxOffset) {
      minOffset = maxOffset;
    }

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
                'Freq: ',
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
                min: minOffset,
                max: maxOffset,
                value: frequencyOffset.clamp(minOffset, maxOffset),
                onChanged: onFrequencyOffsetChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}