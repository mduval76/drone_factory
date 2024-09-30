import 'package:drone_factory/views/widgets/main_volume_widget.dart';
import 'package:drone_factory/views/widgets/oscilloscope_widget.dart';
import 'package:flutter/material.dart';

class MainVolumeOscilloscopeSection extends StatefulWidget {
  const MainVolumeOscilloscopeSection({super.key});

  @override
  State<MainVolumeOscilloscopeSection> createState() => _MainVolumeOscilloscopeSectionState();
}

class _MainVolumeOscilloscopeSectionState extends State<MainVolumeOscilloscopeSection> {

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: MainVolumeWidget(leftChannelVolume: 0.65, rightChannelVolume: 0.75),
          ),
          Expanded(
            flex: 8,
            child: OscilloscopeWidget(),
          )
        ],
      ),
    );
  }
}