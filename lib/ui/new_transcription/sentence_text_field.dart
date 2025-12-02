import 'package:flutter/material.dart';

class SentenceTextField extends StatefulWidget {
  final String initialText;
  final int index;
  final Function(int index, String newText) onUpdate;
  final Function(int index) onDelete;

  const SentenceTextField({
    super.key,
    required this.initialText,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SentenceTextField> createState() => _SentenceTextFieldState();
}

class _SentenceTextFieldState extends State<SentenceTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(covariant SentenceTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText && !_isEditing) {
      _controller.text = widget.initialText;
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  void _saveEdit() {
    final newText = _controller.text.trim();
    if (newText != widget.initialText) {
      widget.onUpdate(widget.index, newText);
    }
    setState(() {
      _isEditing = false;
    });
    _focusNode.unfocus();
  }

  void _delete() {
    widget.onDelete(widget.index);
    setState(() {
      _isEditing = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              style: const TextStyle(fontSize: 20),
              onFieldSubmitted: (_) => _saveEdit(),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: _saveEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Save',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _delete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      );
    }
    return InkWell(
      onTap: _startEditing,
      child: Text(
        widget.initialText,
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
