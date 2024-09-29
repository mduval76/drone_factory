import 'package:drone_factory/views/widgets/main_volume_widget.dart';
import 'package:drone_factory/views/widgets/oscilloscope_widget.dart';
import 'package:flutter/material.dart';

class MainVolumeOscilloscopeSection extends StatelessWidget {
  const MainVolumeOscilloscopeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: const Color.fromARGB(255, 255, 4, 192),
            width: 2,
          ),
        ),
        child: const Row(
          children: [
            MainVolumeWidget(leftChannelVolume: 0.65, rightChannelVolume: 0.75),
            OscilloscopeWidget(),
          ],
        ),
      ),
    );
  }
}