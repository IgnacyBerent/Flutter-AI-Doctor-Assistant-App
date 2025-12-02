import 'package:ai_doctor_assistant/ui/new_transcription/sentence_text_field.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

const _secondsBeforeStopping = 3;

class NewTransciptionView extends StatefulWidget {
  const NewTransciptionView({super.key});

  @override
  State<NewTransciptionView> createState() => _NewTransciptionViewState();
}

class _NewTransciptionViewState extends State<NewTransciptionView> {
  final SpeechToText _speechToText = SpeechToText();

  final _sentences = <String>[];
  String _lastWords = '';
  final TextEditingController _newSentenceController = TextEditingController();
  bool _isAddingNewSentence = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      pauseFor: const Duration(seconds: _secondsBeforeStopping),
      listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        _sentences.add(_lastWords);
        _lastWords = '';
      }
    });
  }

  void _addSentence() {
    final newText = _newSentenceController.text.trim();
    setState(() {
      _sentences.add(newText);
      _isAddingNewSentence = false;
    });
    _focusNode.unfocus();
  }

  void _startAddingNewSentence() {
    setState(() {
      _isAddingNewSentence = true;
      _focusNode.requestFocus();
    });
  }

  void _updateSentence(int index, String newText) {
    if (index >= 0 && index < _sentences.length) {
      setState(() {
        _sentences[index] = newText;
      });
    }
  }

  void _deleteSentence(int index) {
    if (index >= 0 && index < _sentences.length) {
      setState(() {
        _sentences.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._sentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SentenceTextField(
                initialText: sentence,
                index: index,
                onUpdate: _updateSentence,
                onDelete: _deleteSentence,
              ),
            );
          }),

          if (_lastWords.isNotEmpty)
            Text(
              _lastWords,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
            ),

          if (_isAddingNewSentence)
            TextFormField(
              controller: _newSentenceController,
              focusNode: _focusNode,
              maxLines: null,
              style: const TextStyle(fontSize: 20),
              onFieldSubmitted: (_) => _addSentence(),
            ),

          if (_speechToText.isListening)
            IconButton(
              alignment: Alignment.center,
              onPressed: _speechToText.isListening
                  ? _stopListening
                  : _startListening,
              tooltip: 'Listen',
              icon: Icon(Icons.mic_off),
            ),

          if (_speechToText.isNotListening)
            Row(
              spacing: 5,
              children: [
                IconButton(
                  alignment: Alignment.center,
                  onPressed: _speechToText.isListening
                      ? _stopListening
                      : _startListening,
                  tooltip: 'SpeechToText',
                  icon: Icon(Icons.mic),
                ),
                IconButton(
                  alignment: Alignment.center,
                  onPressed: _startAddingNewSentence,
                  tooltip: 'Type',
                  icon: Icon(Icons.keyboard),
                ),
                IconButton(
                  alignment: Alignment.center,
                  onPressed: () => {},
                  tooltip: 'Finish',
                  icon: Icon(Icons.check_circle),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
