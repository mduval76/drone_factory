import 'package:flutter/material.dart';

class TrackVolume extends StatelessWidget {
  final double volume;
  final Color borderColor;
  final ValueChanged<double> onVolumeChanged;

  const TrackVolume({
    super.key,
    required this.volume,
    required this.borderColor,
    required this.onVolumeChanged,
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
                'Vol:',
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
                min: 0,
                max: 1,
                value: volume,
                onChanged: onVolumeChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}