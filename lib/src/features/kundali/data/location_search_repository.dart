import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../domain/place_suggestion.dart';

final locationSearchRepositoryProvider = Provider<LocationSearchRepository>((
  ref,
) {
  final client = http.Client();
  ref.onDispose(client.close);
  return OpenMeteoLocationSearchRepository(httpClient: client);
});

abstract class LocationSearchRepository {
  Future<List<PlaceSuggestion>> search(String query, {int limit = 8});
}

class LocationSearchException implements Exception {
  const LocationSearchException({
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
    if (code == null) return 'LocationSearchException: $message';
    return 'LocationSearchException($code): $message';
  }
}

class OpenMeteoLocationSearchRepository implements LocationSearchRepository {
  OpenMeteoLocationSearchRepository({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;

  @override
  Future<List<PlaceSuggestion>> search(String query, {int limit = 8}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const <PlaceSuggestion>[];

    final safeLimit = limit.clamp(1, 20);
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': trimmed,
      'count': safeLimit.toString(),
      'language': 'en',
      'format': 'json',
    });

    final response = await _http.get(
      uri,
      headers: const <String, String>{'Accept': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LocationSearchException(
        message: 'Request failed',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final Map<String, dynamic> json;
    try {
      final raw = jsonDecode(response.body);
      if (raw is Map<String, dynamic>) {
        json = raw;
      } else if (raw is Map) {
        json = raw.map((k, v) => MapEntry(k.toString(), v));
      } else {
        throw const FormatException('Expected JSON object');
      }
    } catch (_) {
      throw LocationSearchException(
        message: 'Invalid JSON response',
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final results = json['results'];
    if (results is! List) return const <PlaceSuggestion>[];

    final out = <PlaceSuggestion>[];
    for (final item in results) {
      final place = _parsePlace(item);
      if (place != null) out.add(place);
    }
    return out;
  }
}

PlaceSuggestion? _parsePlace(Object? raw) {
  final map = _asMap(raw);
  if (map == null) return null;

  final name = _asString(map['name']);
  final lat = _asDouble(map['latitude']);
  final lon = _asDouble(map['longitude']);
  if (name == null || lat == null || lon == null) return null;

  return PlaceSuggestion(
    name: name,
    latitude: lat,
    longitude: lon,
    country: _asString(map['country']),
    admin1: _asString(map['admin1']),
    timezone: _asString(map['timezone']),
  );
}

Map<String, dynamic>? _asMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}

String? _asString(Object? raw) {
  if (raw == null) return null;
  if (raw is String) return raw;
  return raw.toString();
}

double? _asDouble(Object? raw) {
  if (raw == null) return null;
  if (raw is double) return raw;
  if (raw is int) return raw.toDouble();
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw.trim());
  return null;
}
