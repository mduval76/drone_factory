import 'package:drone_factory/models/patch.dart';
import 'package:drone_factory/models/track.dart';
import 'package:flutter/foundation.dart';

class PatchProvider extends ChangeNotifier {
  Patch _currentPatch;
  final VoidCallback? onPatchLoaded;
  
  PatchProvider({this.onPatchLoaded}) : _currentPatch = _initializeDefaultPatch();

  Patch get currentPatch => _currentPatch;

  static Patch _initializeDefaultPatch() {
    return Patch(
      userId: 'user1',
      patchName: 'default',
      tracks: List.generate(8, (index) => Track(trackId: index)),
      isSaved: false,
    );
  }
  
  void savePatch(int patchId) {
    _currentPatch = _currentPatch.copyWith(
      patchId: patchId,
      isSaved: true,
    );
    notifyListeners();
  }

  void loadPatch(Patch newPatch) {
    _currentPatch = newPatch;
    onPatchLoaded?.call();
    notifyListeners();
  }

  void resetPatch() {
    _currentPatch = _initializeDefaultPatch();
    notifyListeners();
  }

  void addTrackToPatch(Track track) {
    _currentPatch.tracks.add(track);
    notifyListeners();
  }

  void updatePatchName(String name) {
    _currentPatch = Patch(
      patchId: _currentPatch.patchId,
      userId: _currentPatch.userId,
      patchName: name,
      tracks: _currentPatch.tracks,
      isSaved: _currentPatch.isSaved
    );
    notifyListeners();
  }
}
