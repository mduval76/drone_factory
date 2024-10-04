class TrackModel {
  final int trackId;
  final double volume;
  final double frequency;
  final Wavetable wavetable;

  const TrackModel({
    required this.trackId,
    this.volume = 1.0,
    this.frequency = 440.0,
    this.wavetable = Wavetable.sine,
  });
}

enum Wavetable {
  sine,
  triangle,
  square,
  sawtooth,
}