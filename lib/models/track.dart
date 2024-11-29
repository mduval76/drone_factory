class Track {
  final int trackId;
  int patchId;
  bool isMuted;
  bool isSoloed;
  bool isActive;
  double volume;
  double frequencyOffset;
  Wavetable wavetable;

  Track({
    required this.trackId,
    this.patchId = 0,
    this.isMuted = false,
    this.isSoloed = false,
    this.isActive = false,
    this.volume = 0.0,
    this.frequencyOffset = 0.0,
    this.wavetable = Wavetable.none,
  });
  
  Map<String, Object?> toMap() {
    return {
      'trackId': trackId,
      'patchId': patchId,
      'isMuted': isMuted ? 1 : 0,
      'isSoloed': isSoloed ? 1 : 0,
      'isActive': isActive ? 1 : 0,
      'volume': volume,
      'frequencyOffset': frequencyOffset,
      'wavetable': wavetable.index,
    };
  }

  double getAbsoluteFrequency(double baseFrequency) {
    return baseFrequency + frequencyOffset;
  }
}

enum Wavetable {
  sine,
  triangle,
  square,
  sawtooth,
  none
}