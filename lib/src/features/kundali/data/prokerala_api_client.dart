import 'dart:convert';

import 'package:http/http.dart' as http;

class ProkeralaApiException implements Exception {
  const ProkeralaApiException({
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
    if (code == null) return 'ProkeralaApiException: $message';
    return 'ProkeralaApiException($code): $message';
  }
}

class ProkeralaApiClient {
  ProkeralaApiClient({required this.baseUrl, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _http;

  Uri _uri(String path, Map<String, String> query) {
    final trimmedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final trimmedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$trimmedBase$trimmedPath',
    ).replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> getJson({
    required String path,
    required Map<String, String> query,
    required String accessToken,
  }) async {
    final response = await _http.get(
      _uri(path, query),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProkeralaApiException(
        message: 'Request failed',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    try {
      final raw = jsonDecode(response.body);
      if (raw is Map<String, dynamic>) return raw;
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k.toString(), v));
      }
      throw const FormatException('Expected JSON object');
    } catch (e) {
      throw ProkeralaApiException(
        message: 'Invalid JSON response',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}
