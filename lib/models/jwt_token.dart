import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtToken {
  static final JwtToken _instance = JwtToken._internal();
  factory JwtToken() {
    return _instance;
  }
  JwtToken._internal();
  static const String _tokenKey = 'access_token';

  final storage = const FlutterSecureStorage();

  Future<void> saveTokens(Map<String, dynamic> loginResponse) async {
    await storage.write(key: _tokenKey, value: loginResponse[_tokenKey]);
  }

  Future<void> updateToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) {
      return true;
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      return true;
    }

    final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
    final jwtPayload = json.decode(payload);
    if (DateTime.fromMillisecondsSinceEpoch(
      jwtPayload['exp'] * 1000,
    ).isBefore(DateTime.now())) {
      return true;
    }

    return false;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }
}
