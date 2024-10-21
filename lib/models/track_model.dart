class TrackModel {
  final int trackId;
  bool isMuted = false;
  bool isActive = false;
  double volume;
  double frequency;
  Wavetable wavetable;

  TrackModel({
    required this.trackId,
    this.isMuted = false,
    this.isActive = false,
    this.volume = 0.0,
    this.frequency = 110.0,
    this.wavetable = Wavetable.none,
  });
}

enum Wavetable {
  sine,
  triangle,
  square,
  sawtooth,
  none
}