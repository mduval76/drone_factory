import 'package:drone_factory/views/sections/main_menu_section.dart';
import 'package:drone_factory/views/sections/main_mixer_track_controls_section.dart';
import 'package:drone_factory/views/sections/main_volume_oscilloscope_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spacing = screenHeight < 600 ? 5.0 : 10.0;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          const MainVolumeOscilloscopeSection(),
          SizedBox(height: spacing),
          const MainMenuSection(),
          SizedBox(height: spacing),
          const MainMixerTrackControlsSection(),
        ],
      ),
    );
  }
}