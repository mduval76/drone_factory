import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeSynthesizer {
  static const _channel = MethodChannel('u9343789.drone_factory/synth_channel');

  Stream<List<double>> get visualizationDataStream => 
    Stream.periodic(const Duration(milliseconds: 16))
      .asyncMap((_) async {
        try {
          final data = await getVisualizationData();
          if (data != null) {
            return data;
          }
          return <double>[];
        } 
        catch (e) {
          debugPrint("Failed to fetch visualization data: '$e'.");
          return <double>[];
        }
      })
      .where((data) => data.isNotEmpty); 

  Future<void> play() async {
    try {
      await _channel.invokeMethod('play');
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to play: '${e.message}'.");
    }
  }
  
  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to stop: '${e.message}'.");
    }
  }

  Future<bool> isPlaying() async {
    try {
      final bool isPlaying = await _channel.invokeMethod('isPlaying');
      return isPlaying;
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to check if playing: '${e.message}'.");
      return false;
    }
  }

  Future<void> setFrequency(int trackId, double frequency) async {
    try {
      await _channel.invokeMethod('setFrequency', {"trackId": trackId, "frequency": frequency});
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to set frequency: '${e.message}'.");
    }
  }

  Future<void> setVolume(int trackId, double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {"trackId": trackId, "volume": volume});
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to set volume: '${e.message}'.");
    }
  }

  Future<void> setWavetable(int trackId, int wavetable) async {
    try {
      await _channel.invokeMethod('setWavetable', {"trackId": trackId, "wavetable": wavetable});
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to set wavetable: '${e.message}'.");
    }
  }

  Future<void> setIsMuted(int trackId, bool isMuted) async {
    try {
      await _channel.invokeMethod('setIsMuted', {"trackId": trackId, "isMuted": isMuted});
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to set muted: '${e.message}'.");
    }
  }

  Future<void> setIsSoloed(int trackId, bool isSoloed) async {
    try {
      await _channel.invokeMethod('setIsSoloed', {"trackId": trackId, "isSoloed": isSoloed});
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to set soloed: '${e.message}'.");
    }
  }

  Future<List<double>?> getVisualizationData() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod('getVisualizationData');
      return result?.cast<double>();
    } 
    on PlatformException catch (e) {
      debugPrint("Failed to fetch visualization data: '${e.message}'.");
      return null;
    }
  }
}