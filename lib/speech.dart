import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speech extends StatefulWidget {
  const Speech({super.key});

  @override
  State<Speech> createState() => _SpeachState();
}

class _SpeachState extends State<Speech> {
  final SpeechToText _speechToText = SpeechToText();

  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Initializes the speech recognition service
  void _initSpeech() async {
    // This requests microphone permission and checks service availability
    setState(() {});
  }

  /// Start listening for speech
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stop listening and update the UI with the final result
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This callback is invoked when the platform returns recognized words
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // ... your UI to display status and text goes here
          Text(_lastWords),
          IconButton(
            onPressed: _speechToText.isListening
                ? _stopListening
                : _startListening,
            tooltip: 'Listen',
            icon: Icon(
              _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            ),
          ),
        ],
      ),
    );
  }
}
