import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/models/patch.dart';
import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/providers/base_frequency_provider.dart';
import 'package:drone_factory/utils/constants.dart';
import 'package:flutter/foundation.dart';

class TrackProvider extends ChangeNotifier {
  final NativeSynthesizer _synthesizer;
  final BaseFrequencyProvider _baseFrequencyProvider;
  Patch _currentPatch;

  TrackProvider(
    this._synthesizer, 
    this._currentPatch, 
    this._baseFrequencyProvider
  ) {
    _baseFrequencyProvider.addListener(_onBaseFrequencyChanged);
    _initializeTrackFrequencies();
  }

  List<Track> get tracks => _currentPatch.tracks;
  Patch get currentPatch => _currentPatch;
  NativeSynthesizer get synthesizer => _synthesizer;

  void _initializeTrackFrequencies() {
    for (var track in _currentPatch.tracks) {
      double absoluteFrequency = track.getAbsoluteFrequency(_baseFrequencyProvider.baseFrequency);
      _synthesizer.setFrequency(track.trackId, absoluteFrequency);
    }
  }

  void _onBaseFrequencyChanged() {
    for (var track in _currentPatch.tracks) {
      double absoluteFrequency = track.getAbsoluteFrequency(_baseFrequencyProvider.baseFrequency);
      _synthesizer.setFrequency(track.trackId, absoluteFrequency);
    }
    notifyListeners();
  }

  void loadTracksFromPatch(Patch patch) {
    for (var track in _currentPatch.tracks) {
      double absoluteFrequency = track.getAbsoluteFrequency(_baseFrequencyProvider.baseFrequency);
      _synthesizer.setWavetable(track.trackId, track.wavetable.index);
      _synthesizer.setFrequency(track.trackId, absoluteFrequency);
      _synthesizer.setVolume(track.trackId, track.volume);
      _synthesizer.setIsMuted(track.trackId, track.isMuted);
      _synthesizer.setIsSoloed(track.trackId, track.isSoloed);
    }
  }

  void updateTracks(Patch newPatch) {
    _currentPatch = newPatch;
    loadTracksFromPatch(newPatch);
    notifyListeners();
  }

  void updateTrackMute(int trackId, bool isMuted) async {
    _currentPatch.tracks[trackId].isMuted = isMuted;

    if (isMuted == false) {
      for(var track in _currentPatch.tracks) {
        if (track.isSoloed) {
          track.isSoloed = false;
        }
      }
    }

    await _synthesizer.setIsMuted(trackId, _currentPatch.tracks[trackId].isMuted);
    notifyListeners();
  }

  void updateTrackSolo(int trackId, bool isSoloed) async {
    Track soloedTrack = _currentPatch.tracks[trackId];
    soloedTrack.isSoloed = isSoloed;

    if (soloedTrack.isMuted) {
      soloedTrack.isMuted = false;
    }

    for (var track in _currentPatch.tracks) {
      if (track.trackId != trackId && track.isActive) {
        track.isMuted = isSoloed;
        track.isSoloed = false;
      }
    }

    await _synthesizer.setIsSoloed(trackId, soloedTrack.isSoloed);
    notifyListeners();
  }

  Future<void> updateTrackFrequencyOffset(int trackId, double newOffset) async {
    var track = _currentPatch.tracks[trackId];
    track.frequencyOffset = newOffset;

    double absoluteFrequency = track.getAbsoluteFrequency(_baseFrequencyProvider.baseFrequency);
    await _synthesizer.setFrequency(track.trackId, absoluteFrequency);

    notifyListeners();
  }

  Future<void> updateFrequencies(double difference) async {
    bool shouldStopUpdating = false;
    
    for (var track in _currentPatch.tracks) {
      if (shouldStopUpdating) {
        return;
      }

      track.frequencyOffset += difference;

      if (track.frequencyOffset < 10) {
        track.frequencyOffset = 10;
        shouldStopUpdating = true;
      }
      await _synthesizer.setFrequency(track.trackId, track.frequencyOffset);
    }
    notifyListeners();
  }

  Future<void> resetTracks() async {
    for (var track in _currentPatch.tracks) {
      await _synthesizer.setVolume(track.trackId, 0.0);
      await _synthesizer.setFrequency(track.trackId, AudioConstants.defaultFrequency);
      await _synthesizer.setWavetable(track.trackId, Wavetable.none.index);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _baseFrequencyProvider.removeListener(_onBaseFrequencyChanged);
    super.dispose();
  }
}
