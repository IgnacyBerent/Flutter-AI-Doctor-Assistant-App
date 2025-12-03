import 'dart:developer';

import 'package:ai_doctor_assistant/models/jwt_token.dart';
import 'package:ai_doctor_assistant/models/transcription_history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiUrl = "https://remisio.pl/api/users/1";

Future<String> getTranscription(String text) async {
  final jwt = JwtToken();
  final token = await jwt.getToken();

  try {
    final response = await http.post(
      Uri.parse("$apiUrl/transcription"),
      body: json.encode({"transcript": text}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody.toString();
    } else {
      throw Exception("Api error: ${response.statusCode}");
    }
  } catch (e) {
    log("Error on transcript $e");
    rethrow;
  }
}

Future<List<TranscriptionHistory>> getTranscriptionHistory() async {
  final jwt = JwtToken();
  final token = await jwt.getToken();

  try {
    final response = await http.get(
      Uri.parse("$apiUrl/transcription"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => TranscriptionHistory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load history: Status ${response.statusCode}');
    }
  } catch (e) {
    log("Error fetching history: $e");
    rethrow;
  }
}
