import 'package:drone_factory/models/track.dart';

class Patch {
  final int? patchId;
  final String userId;
  final String patchName;
  final List<Track> tracks;
  bool isSaved;
  DateTime creationDate;

  Patch({
    this.patchId,
    required this.userId,
    required this.patchName,
    required this.tracks,
    required this.isSaved,
    DateTime? creationDate,
  }) : creationDate = creationDate ?? DateTime.now();

  Patch copyWith({
    int? patchId,
    String? userId,
    String? patchName,
    List<Track>? tracks,
    bool? isSaved,
    DateTime? creationDate,
  }) {
    return Patch(
      patchId: patchId ?? this.patchId,
      userId: userId ?? this.userId,
      patchName: patchName ?? this.patchName,
      tracks: tracks ?? this.tracks,
      isSaved: isSaved ?? this.isSaved,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'userId': userId,
      'patchName': patchName,
      'isSaved': isSaved ? 1 : 0,
      'creationDate': creationDate.toIso8601String(),
    };
    if (patchId != null) {
      map['patchId'] = patchId as Object;
    }
    return map;
  }
}