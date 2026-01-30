import 'dart:convert';

import 'package:http/http.dart' as http;

class ProkeralaOAuthException implements Exception {
  const ProkeralaOAuthException({
    required this.message,
    this.statusCode,
    this.body,
  });

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() {
    final code = statusCode;
    if (code == null) return 'ProkeralaOAuthException: $message';
    return 'ProkeralaOAuthException($code): $message';
  }
}

class ProkeralaAccessToken {
  const ProkeralaAccessToken({required this.token, required this.expiresAt});

  final String token;
  final DateTime expiresAt;

  bool get isExpired {
    // Add a small buffer so we refresh before the server rejects it.
    final now = DateTime.now();
    return now.isAfter(expiresAt.subtract(const Duration(seconds: 20)));
  }
}

class ProkeralaOAuthClient {
  ProkeralaOAuthClient({required this.tokenUrl, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final String tokenUrl;
  final http.Client _http;

  ProkeralaAccessToken? _cached;

  Future<String> getValidAccessToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final cached = _cached;
    if (cached != null && !cached.isExpired) return cached.token;

    final token = await _fetchToken(
      clientId: clientId,
      clientSecret: clientSecret,
    );
    _cached = token;
    return token.token;
  }

  Future<ProkeralaAccessToken> _fetchToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final uri = Uri.parse(tokenUrl);
    final response = await _http.post(
      uri,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProkeralaOAuthException(
        message: 'Token request failed',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final map = _decodeMap(response.body);
    final accessToken = map['access_token']?.toString();
    final expiresIn = _parseInt(map['expires_in']);
    if (accessToken == null || accessToken.isEmpty || expiresIn == null) {
      throw ProkeralaOAuthException(
        message: 'Invalid token response',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    return ProkeralaAccessToken(
      token: accessToken,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }
}

Map<String, dynamic> _decodeMap(String body) {
  final raw = jsonDecode(body);
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  throw const FormatException('Expected JSON object');
}

int? _parseInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is double) return raw.round();
  if (raw is String) return int.tryParse(raw.trim());
  return null;
}
