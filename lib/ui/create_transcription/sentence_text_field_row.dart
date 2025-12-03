import 'package:flutter/material.dart';

class SentenceTextFieldRow extends StatelessWidget {
  final TextFormField textFormField;
  final void Function() onSave;
  final void Function() onDelete;

  const SentenceTextFieldRow({
    super.key,
    required this.textFormField,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: textFormField),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onSave,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Save',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Delete',
            ),
          ],
        ),
      ],
    );
  }
}
