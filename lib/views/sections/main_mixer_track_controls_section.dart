import 'package:drone_factory/views/widgets/mixer_widget.dart';
import 'package:flutter/material.dart';

class MainMixerTrackControlsSection extends StatelessWidget {
  const MainMixerTrackControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Colors.black,
          border: Border.all(
            color: const Color.fromARGB(255, 255, 4, 192),
            width: 2,
          ),
        ),
        child: const Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  MixerWidget(),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'Track Controls',
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                    fontFamily: 'CocomatLight',
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            )
          ],
        ),
      ),
    ); 
  }
}