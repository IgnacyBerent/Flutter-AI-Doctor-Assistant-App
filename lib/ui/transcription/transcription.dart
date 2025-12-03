import 'package:ai_doctor_assistant/ui/transcription/transcription_markdown.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Transcription extends StatelessWidget {
  final Future<String> Function() fetchFunction;
  final String appBarText;
  const Transcription({
    super.key,
    required this.fetchFunction,
    required this.appBarText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarText)),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchFunction(),
          builder: (context, snapshot) {
            // State 1: Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    "Fetching Doctor's Report...",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TranscriptionMarkdown(data: snapshot.data!),
              );
            }

            return const Text('No content available.');
          },
        ),
      ),
    );
  }
}
