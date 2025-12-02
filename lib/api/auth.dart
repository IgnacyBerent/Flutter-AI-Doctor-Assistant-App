import 'dart:developer';

import 'package:ai_doctor_assistant/api/jwt_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authUrl = Uri.parse("https://remisio.pl/auth/login");

Future<bool> login(String email, String password) async {
  final jwt = JwtToken();
  try {
    final response = await http.post(
      authUrl,
      body: json.encode({'email': email, 'password': password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      await jwt.saveTokens(responseBody);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    log('Login network error: $e');
    rethrow;
  }
}

Future<void> logout() async {
  final jwt = JwtToken();
  await jwt.deleteToken();
}
