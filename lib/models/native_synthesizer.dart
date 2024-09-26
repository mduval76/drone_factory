import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeSynthesizer {
  static const _channel = MethodChannel('u9343789.drone_factory/synth_channel');

  Future<void> play() async {
    try {
      await _channel.invokeMethod('play');
    } on PlatformException catch (e) {
      debugPrint("Failed to play: '${e.message}'.");
    }
  }
  
  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } on PlatformException catch (e) {
      debugPrint("Failed to stop: '${e.message}'.");
    }
  }

  Future<bool> isPlaying() async {
    try {
      final bool isPlaying = await _channel.invokeMethod('isPlaying');
      return isPlaying;
    } on PlatformException catch (e) {
      debugPrint("Failed to check if playing: '${e.message}'.");
      return false;
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', volume);
    } on PlatformException catch (e) {
      debugPrint("Failed to set volume: '${e.message}'.");
    }
  }

  Future<void> setFrequency(double frequency) async {
    try {
      await _channel.invokeMethod('setFrequency', {"frequency": frequency});
    } on PlatformException catch (e) {
      debugPrint("Failed to set frequency: '${e.message}'.");
    }
  }

  Future<void> setWavetable(int wavetable) async {
    try {
      await _channel.invokeMethod('setWavetable', wavetable);
    } on PlatformException catch (e) {
      debugPrint("Failed to set wavetable: '${e.message}'.");
    }
  }
}