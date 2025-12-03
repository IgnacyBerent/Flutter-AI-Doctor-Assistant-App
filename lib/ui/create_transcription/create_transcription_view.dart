import 'package:ai_doctor_assistant/api/api.dart';
import 'package:ai_doctor_assistant/ui/create_transcription/common.dart';
import 'package:ai_doctor_assistant/ui/create_transcription/confirmation_popup.dart';
import 'package:ai_doctor_assistant/ui/create_transcription/sentence_text_field.dart';
import 'package:ai_doctor_assistant/ui/create_transcription/sentence_text_field_row.dart';
import 'package:ai_doctor_assistant/ui/transcription/transcription.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

const _secondsBeforeStopping = 3;

class CreateTransciptionView extends StatefulWidget {
  const CreateTransciptionView({super.key});

  @override
  State<CreateTransciptionView> createState() => _CreateTransciptionViewState();
}

class _CreateTransciptionViewState extends State<CreateTransciptionView> {
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
      if (newText.isNotEmpty) {
        _sentences.add(newText);
        _isAddingNewSentence = false;
      }
    });
    _newSentenceController.clear();
    _focusNode.unfocus();
  }

  void _startAddingNewSentence() {
    setState(() {
      _isAddingNewSentence = true;
      _focusNode.requestFocus();
    });
  }

  void _cancelAddingNewSentence() {
    setState(() {
      _isAddingNewSentence = false;
    });
    _newSentenceController.clear();
    _focusNode.unfocus();
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

  void _clear(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      'Confirm Deletion',
      'Are you sure you want to permanently delete this transcription? This action cannot be undone.',
      "Delete",
    );
    if (confirmed) {
      setState(() {
        _sentences.clear();
      });
    }
  }

  void _onSubmit(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      "Confirm Transcription",
      "Are you sure you have finished transcription?",
      "Yes",
    );
    if (confirmed && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Transcription(
            fetchFunction: () => getTranscription(_sentences.join()),
            appBarText: "",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _newSentenceController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._sentences.asMap().entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SentenceTextField(
                    initialText: entry.value,
                    index: entry.key,
                    onUpdate: _updateSentence,
                    onDelete: _deleteSentence,
                  ),
                ),
                const Divider(color: Colors.grey, height: 1, thickness: 1),
              ],
            );
          }),

          if (_lastWords.isNotEmpty)
            Text(
              _lastWords,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
              textAlign: TextAlign.start,
            ),

          if (_isAddingNewSentence)
            SentenceTextFieldRow(
              textFormField: TextFormField(
                controller: _newSentenceController,
                focusNode: _focusNode,
                maxLines: null,
                style: textStyle,
                onFieldSubmitted: (_) => _addSentence(),
                decoration: textFieldDecoration,
              ),
              onSave: _addSentence,
              onDelete: _cancelAddingNewSentence,
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

          if (_speechToText.isNotListening) ...[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  onPressed: () => _clear(context),
                  tooltip: 'Clear',
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  alignment: Alignment.center,
                  onPressed: () => _onSubmit(context),
                  tooltip: 'Finish',
                  icon: Icon(Icons.check_circle),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
