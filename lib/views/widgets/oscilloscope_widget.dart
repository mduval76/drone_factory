import 'package:flutter/material.dart';

class OscilloscopeWidget extends StatefulWidget {
  const OscilloscopeWidget({super.key});

  @override
  State<OscilloscopeWidget> createState() => _OscilloscopeWidgetState();
}

class _OscilloscopeWidgetState extends State<OscilloscopeWidget> {

  @override
  Widget build(BuildContext context) {
    return const Text(
        'Oscilloscope',
        style: TextStyle(
          color: Colors.lightGreen,
          fontSize: 20,
          fontFamily: 'CocomatLight',
          fontWeight: FontWeight.bold
        ),
      );
  }
}