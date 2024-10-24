import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackWavetableSelectorWidget extends StatelessWidget {
  final Wavetable selectedWavetable;
  final ValueChanged<int> onWavetableSelected;
  final Color borderColor;

  const TrackWavetableSelectorWidget({
    super.key,
    required this.selectedWavetable,
    required this.onWavetableSelected,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
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
          return Expanded(
            child: Container(
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
                  color: selectedWavetable == wavetable ? borderColor : Colors.white,
                ),
                onPressed: () {
                  onWavetableSelected(wavetable.index);
                },
              ),
            ),
          )
          );
        }).toList(),
      ),
    );
  }
}