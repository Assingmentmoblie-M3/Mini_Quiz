import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // keeps row tight in DataCell
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 248, 128, 15)),
          tooltip: "Edit",
          onPressed: onEdit,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 252, 0, 0)),
          tooltip: "Delete",
          onPressed: onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
