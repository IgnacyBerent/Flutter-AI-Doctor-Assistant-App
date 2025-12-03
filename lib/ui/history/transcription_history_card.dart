import 'package:ai_doctor_assistant/models/transcription_history.dart';
import 'package:ai_doctor_assistant/ui/transcription/transcription.dart';
import 'package:flutter/material.dart';

class TranscriptionHistoryCard extends StatelessWidget {
  final TranscriptionHistory transcriptionHistoryItem;
  final BuildContext context;

  const TranscriptionHistoryCard({
    super.key,
    required this.transcriptionHistoryItem,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final truncatedId = '${transcriptionHistoryItem.id.substring(0, 10)}...';

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.history_edu, color: Colors.blueGrey),
        title: Text(
          'ID: $truncatedId',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          transcriptionHistoryItem.extractHPI(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black87.withValues(alpha: 0.8)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Transcription(
                fetchFunction: () =>
                    Future.value(transcriptionHistoryItem.transcript),
                appBarText: truncatedId,
              ),
            ),
          );
        },
      ),
    );
  }
}
