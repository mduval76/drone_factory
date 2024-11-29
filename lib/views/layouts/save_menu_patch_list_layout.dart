import 'package:drone_factory/data/db_handler.dart';
import 'package:drone_factory/models/patch.dart';
import 'package:drone_factory/providers/patch_provider.dart';
import 'package:drone_factory/providers/track_provider.dart';
import 'package:drone_factory/views/layouts/save_menu_patch_list/patch_list.dart';
import 'package:drone_factory/views/layouts/save_menu_patch_list/save_menu.dart';
import 'package:drone_factory/utils/name_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveMenuPatchListLayout extends StatefulWidget {
  const SaveMenuPatchListLayout({super.key});

  @override
  State<SaveMenuPatchListLayout> createState() => _SaveMenuPatchListLayoutState();
}

class _SaveMenuPatchListLayoutState extends State<SaveMenuPatchListLayout> {
  final GlobalKey<PatchListState> _childKey = GlobalKey<PatchListState>();
  static final NameGenerator _nameGenerator = NameGenerator();
  final DbHandler _dbHandler = DbHandler();
  int? _selectedPatchIndex;
  bool _isFetching = false;
  bool _needsConfirmation = false;
  String _confirmationType = '';
  List<Patch> _patches = [];

  @override
  void initState() {
    super.initState();
    _fetchPatches();
  }

  Future<void> _fetchPatches() async {
    setState(() {
      _isFetching = true;
    });

    try {
      final List<Patch> patches = await _dbHandler.getPatchesByUserId('user1');
      setState(() {
        _patches = patches;
      });
      debugPrint('Number of atches fetched: ${_patches.length}');
    } 
    catch (e) {
      debugPrint('Error fetching patches: $e');
    }

    setState(() {
      _isFetching = false;
    });
  }

  void _handlePatchSelection(int index) {
    setState(() {
      _selectedPatchIndex = (_selectedPatchIndex == index) ? null : index;
    });
  }

  void _handlePatchAdd() {
    String patchName = _nameGenerator.generateDefaultName();

    final newPatch = Patch(
      patchId: null,
      userId: 'user1', // TODO: Replace with actual user ID
      patchName: patchName,
      tracks: [],
      creationDate: DateTime.now(),
      isSaved: false,
    );

    setState(() {
      _patches.insert(0, newPatch);
      _selectedPatchIndex = 0;
    });

    debugPrint('Added new patch: $patchName');
  }

  Future<void> _handlePatchSave() async {
    if (_selectedPatchIndex == null) return;

    final patchProvider = context.read<PatchProvider>();
    final trackProvider = context.read<TrackProvider>();
    Patch selectedPatch = _patches[_selectedPatchIndex!];
    bool isNewPatch = selectedPatch.patchId == null;

    final patchToSave = patchProvider.currentPatch.copyWith(
      patchId: isNewPatch ? null : selectedPatch.patchId,
      patchName: selectedPatch.patchName,
      tracks: trackProvider.tracks,
      isSaved: true,
    );

    try {
      if (isNewPatch) {
        final newPatchId = await _dbHandler.insertPatch(patchToSave);

        setState(() {
          _patches[_selectedPatchIndex!] = patchToSave.copyWith(patchId: newPatchId);
          _selectedPatchIndex = null;
        });

        patchProvider.savePatch(newPatchId);
      } 
      else {
        if (selectedPatch.isSaved) {
          _toggleConfirmation();
          _confirmationType = 'save';
          _childKey.currentState?.displayConfirmationButton(_selectedPatchIndex!, _confirmationType);
        }

        if (_needsConfirmation) {
          return;
        }

        await _dbHandler.updatePatch(patchToSave);

        setState(() {
          _patches[_selectedPatchIndex!] = patchToSave;
          _selectedPatchIndex = null;
        });

        patchProvider.savePatch(patchToSave.patchId!);
        debugPrint('Patch "${patchToSave.patchName}" successfully updated.');
      }
    } 
    catch (e) {
      debugPrint('Error saving patch: $e');
    }

    await _fetchPatches();
  }

  void _handlePatchLoad(BuildContext context) {
    if (_selectedPatchIndex != null) {
      final patchProvider = context.read<PatchProvider>();
      final trackProvider = context.read<TrackProvider>();

      if (!patchProvider.currentPatch.isSaved) {
        _toggleConfirmation();
        _confirmationType = 'load';
        _childKey.currentState?.displayConfirmationButton(_selectedPatchIndex!, _confirmationType);
      }

      if (_needsConfirmation) {
        return;
      }

      final selectedPatch = _patches[_selectedPatchIndex!];

      patchProvider.loadPatch(selectedPatch);
      trackProvider.updateTracks(selectedPatch);

      debugPrint('Loaded patch: ${selectedPatch.patchName}');

      setState(() {
        _patches[_selectedPatchIndex!] = patchProvider.currentPatch;
      });
    } 
    else {
      debugPrint('No patch selected to load.');
    }
  }

  void _handlePatchEdit() {
    if (_selectedPatchIndex != null) {
      debugPrint('Edit patch for index: $_selectedPatchIndex');
    } 
    else {
      debugPrint('No patch selected to edit.');
    }
  }

  Future<void> _handlePatchDelete() async {
    if (_selectedPatchIndex == null) {
      debugPrint('No patch selected to delete.');
      return;
    }

    final selectedPatch = _patches[_selectedPatchIndex!];

    final patchProvider = context.read<PatchProvider>();
    final trackProvider = context.read<TrackProvider>();

     bool isCurrentPatch = patchProvider.currentPatch.patchId == selectedPatch.patchId;

    if (selectedPatch.patchId == null) {
      // UNSAVED PATCH
      setState(() {
        _patches.removeAt(_selectedPatchIndex!);
        _selectedPatchIndex = null;
      });

      debugPrint('Unsaved patch ${selectedPatch.patchName} removed.');
    } 
    else {
      // SAVED PATCH
      if (selectedPatch.isSaved) {
        _toggleConfirmation();
        _confirmationType = 'delete';
        _childKey.currentState?.displayConfirmationButton(_selectedPatchIndex!, _confirmationType);
      }

      if (_needsConfirmation) {
        return;
      }

      try {
        await _dbHandler.deletePatch(selectedPatch.patchId!);

        setState(() {
          _patches.removeAt(_selectedPatchIndex!);
          _selectedPatchIndex = null;
        });

        debugPrint('Patch "${selectedPatch.patchName}" deleted.');
      } 
      catch (e) {
        debugPrint('Error deleting patch: $e');
      }
    }

    if (isCurrentPatch) {
      patchProvider.resetPatch();
      trackProvider.resetTracks();

      debugPrint('Current patch was deleted. Providers have been reset.');
    }
  }

  void _handlePatchCancel() {
    if (_selectedPatchIndex != null) {
      setState(() {
        _selectedPatchIndex = null;
      });
    } 
    else {
      debugPrint('No patch selected to cancel.');
    }
  }

  void _toggleConfirmation() {
    setState(() {
      _needsConfirmation = !_needsConfirmation;
      debugPrint('Needs confirmation? $_needsConfirmation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color.fromARGB(255, 255, 4, 192),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SaveMenu(
              selectedPatchIndex: _selectedPatchIndex,
              onAdd: _handlePatchAdd,
              onSave: _handlePatchSave,
              onEdit: _handlePatchEdit,
              onLoad: () => _handlePatchLoad(context),
              onDelete: _handlePatchDelete,
              onCancel: _handlePatchCancel,
            ),
          ),
          Expanded(
            flex: 5,
            child: PatchList(
              key: _childKey,
              patches: _patches,
              onConfirmation: (String confirmationType) {
                if (confirmationType == 'save') {
                  _handlePatchSave();
                  debugPrint('callback to save');
                }
                else if (confirmationType == 'load') {
                  _handlePatchLoad(context);
                  debugPrint('callback to load');
                } 
                else if (confirmationType == 'delete') {
                  _handlePatchDelete();
                  debugPrint('callback to delete');
                } 
                else {
                  () {};
                }
              },
              onPatchSelected: _handlePatchSelection,
              selectedPatchIndex: _selectedPatchIndex,
              isFetching: _isFetching,
            ),
          ),
        ],
      ),
    );
  }
}