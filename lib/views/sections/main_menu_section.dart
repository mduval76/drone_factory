import 'package:flutter/material.dart';
import '../../models/native_synthesizer.dart';

class MainMenuSection extends StatefulWidget  {
  const MainMenuSection({super.key});

  @override
  State<MainMenuSection> createState() => _MainMenuSectionState();
}

class _MainMenuSectionState extends State<MainMenuSection> {
  bool isPlaying = false;
  final NativeSynthesizer _synthesizer = NativeSynthesizer(); 

  void _togglePlayPause() async {
    if (isPlaying) {
      await _synthesizer.stop();
    } else {
      await _synthesizer.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

@override
  Widget build(BuildContext context) {
    return Expanded(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 4, 192),
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
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color.fromARGB(255, 255, 4, 192),
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
