
import 'package:drone_factory/models/patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatchList extends StatefulWidget {
  final Function(String)? onConfirmation;
  final Function(int)? onPatchSelected;
  final int? selectedPatchIndex;
  final bool isFetching;
  final List<Patch> patches;
  
  const PatchList({
    super.key,
    this.onConfirmation,
    this.onPatchSelected,
    this.selectedPatchIndex,
    required this.isFetching,
    required this.patches,
  });

  @override
  State<PatchList> createState() => PatchListState();
}

class PatchListState extends State<PatchList> {
  String _confirmationType = '';
  int _confirmationIndex = -1;
  bool _needsDisplaying = false;
  
  void displayConfirmationButton(int index, String type) async {
    setState(() {
      _confirmationType = type;
      _confirmationIndex = index;
      _needsDisplaying = true;
    });
  }

  void hideConfirmationButton() {
    setState(() {
      _confirmationIndex = -1;
      _needsDisplaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.patches.length,
      itemBuilder: (context, index) {
        final isSelected = widget.selectedPatchIndex == index;

        return Material(
          color: isSelected ? const Color.fromARGB(255, 78, 78, 78) : Colors.transparent,
          child: ListTile(
            leading: widget.isFetching && isSelected
            ? const SizedBox(
                width: 30, 
                height: 30, 
                child: CircularProgressIndicator()
              ,)
            : Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.patches[index].isSaved ? Colors.lime : Colors.red,
                  width: 2,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.isFetching && isSelected ? '' : widget.patches[index].patchName,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontFamily: 'CocomatLight',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: _needsDisplaying && _confirmationIndex == index 
            ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.zero,
                side: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              child: const Text(
                'SURE?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                widget.onConfirmation?.call(_confirmationType);
                hideConfirmationButton();
                debugPrint('Confirmation at index $index');
              },
            )
            : null,
            selected: isSelected,
            onTap: () {
              if (widget.onPatchSelected != null) {
                final newSelectedIndex = isSelected ? null : index;
                widget.onPatchSelected!(newSelectedIndex ?? -1);
              }
              debugPrint('${isSelected ? "Deselected" : "Selected"} patch $index ');
            },
          ),
        );
      },
    );
  }
}