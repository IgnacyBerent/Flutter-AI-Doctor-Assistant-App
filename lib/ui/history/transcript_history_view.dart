import 'package:ai_doctor_assistant/api/api.dart';
import 'package:ai_doctor_assistant/models/transcription_history.dart';
import 'package:ai_doctor_assistant/ui/history/transcription_history_card.dart';
import 'package:flutter/material.dart';

class TranscriptHistoryView extends StatelessWidget {
  const TranscriptHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TranscriptionHistory>>(
      future: getTranscriptionHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load history: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final history = snapshot.data;

        if (history == null || history.isEmpty) {
          return const Center(child: Text('No past transcriptions found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return TranscriptionHistoryCard(
              transcriptionHistoryItem: history[index],
              context: context,
            );
          },
        );
      },
    );
  }
}
