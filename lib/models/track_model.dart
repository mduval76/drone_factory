class TrackModel {
  final int trackId;
  double volume;
  double frequency;
  Wavetable wavetable;

  TrackModel({
    required this.trackId,
    this.volume = 0.0,
    this.frequency = 440.0,
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