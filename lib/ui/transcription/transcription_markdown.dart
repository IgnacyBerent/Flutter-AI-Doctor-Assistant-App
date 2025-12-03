import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TranscriptionMarkdown extends StatelessWidget {
  final String data;
  const TranscriptionMarkdown({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
        listBullet: const TextStyle(fontSize: 16, color: Colors.black87),
        blockquoteDecoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.blueGrey.shade200),
        ),
      ),
      selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          debugPrint('Tapped link to: $href');
        }
      },
    );
  }
}
