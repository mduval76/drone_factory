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

  Future<void> setFrequency(int trackId, double frequency) async {
    try {
      await _channel.invokeMethod('setFrequency', {"trackId": trackId, "frequency": frequency});
    } on PlatformException catch (e) {
      debugPrint("Failed to set frequency: '${e.message}'.");
    }
  }

  Future<void> setVolume(int trackId, double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {"trackId": trackId, "volume": volume});
    } on PlatformException catch (e) {
      debugPrint("Failed to set volume: '${e.message}'.");
    }
  }

  Future<void> setWavetable(int trackId, int wavetable) async {
    try {
      await _channel.invokeMethod('setWavetable', {"trackId": trackId, "wavetable": wavetable});
    } on PlatformException catch (e) {
      debugPrint("Failed to set wavetable: '${e.message}'.");
    }
  }

  Future<void> setIsMuted(int trackId, bool isMuted) async {
    try {
      await _channel.invokeMethod('setIsMuted', {"trackId": trackId, "isMuted": isMuted});
    } on PlatformException catch (e) {
      debugPrint("Failed to set muted: '${e.message}'.");
    }
  }

  Future<List<double>?> getVisualizationData() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod('getVisualizationData');
      return result?.cast<double>();
    } on PlatformException catch (e) {
      debugPrint("Failed to fetch visualization data: '${e.message}'.");
      return null;
    }
  }
}