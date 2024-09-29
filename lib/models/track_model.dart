class TrackModel {
  final int id;
  final double volume;
  final double frequency;
  final Wavetable wavetable;

  const TrackModel({
    required this.id,
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