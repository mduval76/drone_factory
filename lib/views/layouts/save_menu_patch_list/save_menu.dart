import 'package:flutter/material.dart';

class SaveMenu extends StatelessWidget {
  final int? selectedPatchIndex;
  final void Function() onAdd;
  final void Function() onSave;
  final void Function() onEdit;
  final void Function() onLoad;
  final void Function() onDelete;
  final void Function() onCancel;

  const SaveMenu({
    super.key,
    this.selectedPatchIndex,
    required this.onAdd,
    required this.onSave,
    required this.onEdit,
    required this.onLoad,
    required this.onDelete,
    required this.onCancel,
  });

  Widget _buildIconButton({
    required IconData icon,
    required void Function()? onPressed,
    required bool isEnabled,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: IconButton(
        onPressed: isEnabled ? onPressed : () {},
        iconSize: 40,
        color: Colors.white,
        icon: Icon(icon),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isPatchSelected = (selectedPatchIndex != null && selectedPatchIndex != -1);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          right: BorderSide(
            color: Color.fromARGB(255, 255, 4, 192),
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onAdd,
            iconSize: 50,
            color: Colors.white,
            icon: const Icon(Icons.add),
          ),
          _buildIconButton(
            icon: Icons.save,
            onPressed: onSave,
            isEnabled: isPatchSelected,
          ),
          const SizedBox(height: 10),
          _buildIconButton(
            icon: Icons.edit,
            onPressed: onEdit,
            isEnabled: isPatchSelected,
          ),
          const SizedBox(height: 10),
          _buildIconButton(
            icon: Icons.upload_file,
            onPressed: onLoad,
            isEnabled: isPatchSelected,
          ),
          const SizedBox(height: 10),
          _buildIconButton(
            icon: Icons.delete,
            onPressed: onDelete,
            isEnabled: isPatchSelected,
          ),
          const SizedBox(height: 10),
          _buildIconButton(
            icon: Icons.cancel,
            onPressed: onCancel,
            isEnabled: isPatchSelected,
          ),
        ],
      ),
    );
  }
}