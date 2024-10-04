import 'package:drone_factory/views/sections/main_menu_section.dart';
import 'package:drone_factory/views/sections/main_mixer_track_controls_section.dart';
import 'package:drone_factory/views/sections/main_volume_oscilloscope_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Column(
        children: [
          Expanded(
            flex: 3,
            child: MainVolumeOscilloscopeSection(),
          ), 
          SizedBox(height: 5.0),
          Expanded(
            child: MainMenuSection(),
          ),
          SizedBox(height: 5.0),
          Expanded(
            flex: 6,
            child: MainMixerTrackControlsSection(),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}