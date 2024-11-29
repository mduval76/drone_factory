import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/views/layouts/main_menu_layout.dart';
import 'package:drone_factory/views/layouts/mixer_controls_layout.dart';
import 'package:drone_factory/views/layouts/save_menu_patch_list_layout.dart';
import 'package:drone_factory/views/layouts/volume_oscilloscope_layout.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NativeSynthesizer nativeSynthesizer = NativeSynthesizer();
  bool _showSaveMenu = false;

  void toggleSaveMenu() {
    setState(() {
      _showSaveMenu = !_showSaveMenu;
      debugPrint("Save menu toggled: $_showSaveMenu");
    });
  }

  void navigateToTrackControls() {
    Navigator.pushReplacementNamed(context, '/track_controls');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: VolumeOscilloscopeLayout(nativeSynthesizer : nativeSynthesizer),
          ), 
          const SizedBox(height: 5.0),
          Expanded(
            child: MainMenuLayout(
              onSaveMenuToggled: toggleSaveMenu,
            ),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            flex: 6,
            child: _showSaveMenu
              ? const SaveMenuPatchListLayout()
              : const MixerControlsLayout(),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}