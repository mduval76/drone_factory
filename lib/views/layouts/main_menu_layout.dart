import 'package:drone_factory/providers/auth_provider.dart';
import 'package:drone_factory/providers/patch_provider.dart';
import 'package:drone_factory/views/layouts/main_menu/base_frequency.dart';
import 'package:drone_factory/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:provider/provider.dart';

class MainMenuLayout extends StatefulWidget  {
  final VoidCallback onSaveMenuToggled;

  const MainMenuLayout({
    super.key,
    required this.onSaveMenuToggled
  });

  @override
  State<MainMenuLayout> createState() => _MainMenuLayoutState();
}

class _MainMenuLayoutState extends State<MainMenuLayout> {
  bool _isPlaying = false;
  bool _saveMenuVisible = false;
  final NativeSynthesizer _synthesizer = NativeSynthesizer(); 
  late PatchProvider _patchProvider;

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _synthesizer.stop();
    }
    else {
      await _synthesizer.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleSaveMenu() {
    widget.onSaveMenuToggled();

    setState(() {
      _saveMenuVisible = !_saveMenuVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _patchProvider = PatchProvider(onPatchLoaded: _toggleSaveMenu);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    const Color borderColor = Color.fromARGB(255, 255, 4, 192);
    
    return ChangeNotifierProvider(
      create: (_) => _patchProvider,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: const Color.fromARGB(255, 255, 4, 192),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: _togglePlayPause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                ),
                child: Center(
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: borderColor,
                  ),
                ),
              ),
            ),
            const BaseFrequencyWidget(),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  debugPrint('User is a guest: ${authProvider.isGuest}');
                  //_toggleSaveMenu();
                  if (authProvider.isGuest) {
                    final loginSuccess = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                    if (loginSuccess == true) {
                      _toggleSaveMenu();
                    }
                  } 
                  else {
                    _toggleSaveMenu();
                  }
                },
                child: Center(
                  child: Icon(
                    _saveMenuVisible ? Icons.tune : Icons.save,
                    color:  borderColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}