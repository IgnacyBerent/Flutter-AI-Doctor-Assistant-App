import 'package:ai_doctor_assistant/ui/new_transcription/common.dart';
import 'package:ai_doctor_assistant/ui/new_transcription/sentence_text_field_row.dart';
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
      return SentenceTextFieldRow(
        textFormField: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: null,
          style: textStyle,
          onFieldSubmitted: (_) => _saveEdit(),
          decoration: textFieldDecoration,
        ),
        onSave: _saveEdit,
        onDelete: _delete,
      );
    }
    return InkWell(
      onTap: _startEditing,
      child: Text(
        widget.initialText,
        style: textStyle,
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
