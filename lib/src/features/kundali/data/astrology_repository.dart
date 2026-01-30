import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/birth_details.dart';
import '../domain/kundali_chart.dart';
import '../domain/kundali_failure.dart';
import 'prokerala_api_client.dart';
import 'prokerala_api_config.dart';
import 'prokerala_oauth_client.dart';

abstract class AstrologyRepository {
  Future<KundaliChartData> fetchKundali(BirthDetails details);
}

final astrologyRepositoryProvider = Provider<AstrologyRepository>((ref) {
  final config = ProkeralaApiConfig.fromEnvironment();
  final oauth = ProkeralaOAuthClient(tokenUrl: config.tokenUrl);
  final client = ProkeralaApiClient(baseUrl: config.baseUrl);
  return ProkeralaRepository(config: config, oauth: oauth, client: client);
});

class ProkeralaRepository implements AstrologyRepository {
  ProkeralaRepository({
    required this.config,
    required this.oauth,
    required this.client,
  });

  final ProkeralaApiConfig config;
  final ProkeralaOAuthClient oauth;
  final ProkeralaApiClient client;

  @override
  Future<KundaliChartData> fetchKundali(BirthDetails details) async {
    if (!config.isConfigured) {
      throw const KundaliFailure(
        title: 'API not configured',
        message:
            'Run the app with --dart-define=PROKERALA_CLIENT_ID=... and --dart-define=PROKERALA_CLIENT_SECRET=....',
      );
    }

    try {
      final accessToken = await oauth.getValidAccessToken(
        clientId: config.clientId,
        clientSecret: config.clientSecret,
      );

      final baseQuery = <String, String>{
        'ayanamsa': config.ayanamsa.toString(),
        'coordinates': details.toProkeralaCoordinates(),
        'datetime': details.toProkeralaDateTime(),
        'la': config.language,
      };

      final responses = await Future.wait(<Future<Map<String, dynamic>>>[
        client.getJson(
          path: '/astrology/divisional-planet-position',
          query: <String, String>{...baseQuery, 'chart_type': config.chartType},
          accessToken: accessToken,
        ),
        client.getJson(
          path: '/astrology/planet-position',
          query: <String, String>{
            ...baseQuery,
            'planets': '0,1,2,3,4,5,6,100,101,102',
          },
          accessToken: accessToken,
        ),
      ]);

      final divisional = responses.first;
      final planetPos = responses.last;

      final retroById = _parseRetrogradeByPlanetId(planetPos);
      final ascendantId =
          _parseAscendantSignFromPlanetPosition(planetPos) ??
          _parseAscendantSignFromDivisional(divisional);

      final ascendant = ascendantId == null
          ? null
          : ZodiacSign.fromId(ascendantId);
      if (ascendant == null) {
        throw const KundaliFailure(
          title: 'Unexpected API response',
          message: 'Could not determine ascendant sign from API response.',
        );
      }

      final houseSigns = List<ZodiacSign?>.filled(12, null);
      final housePlanets = List<List<KundaliPlanet>>.generate(
        12,
        (_) => <KundaliPlanet>[],
      );

      _fillFromDivisional(
        divisional,
        retroById: retroById,
        houseSigns: houseSigns,
        housePlanets: housePlanets,
      );

      final resolvedSigns = List<ZodiacSign>.generate(12, (i) {
        final sign = houseSigns[i];
        if (sign != null) return sign;
        final signId = ((ascendant.id + i - 1) % 12) + 1;
        return ZodiacSign.fromId(signId)!;
      });

      final houses = List<KundaliHouse>.generate(12, (i) {
        final planets = housePlanets[i]
          ..sort((a, b) => a.id.displayName.compareTo(b.id.displayName));
        return KundaliHouse(
          number: i + 1,
          sign: resolvedSigns[i],
          planets: planets,
        );
      });

      return KundaliChartData(ascendant: ascendant, houses: houses);
    } on KundaliFailure {
      rethrow;
    } on ProkeralaOAuthException catch (e) {
      throw KundaliFailure(
        title: 'Authentication failed',
        message:
            'Could not authenticate with Prokerala. Check your credentials and try again.',
        details: 'status=${e.statusCode} body=${e.body}',
      );
    } on ProkeralaApiException catch (e) {
      throw KundaliFailure(
        title: 'Prokerala API error',
        message: 'Failed to fetch kundali data. Please try again.',
        details: 'status=${e.statusCode} body=${e.body}',
      );
    } catch (e) {
      throw KundaliFailure(
        title: 'Something went wrong',
        message: 'Unable to generate your kundali right now.',
        details: e.toString(),
      );
    }
  }
}

Map<int, bool> _parseRetrogradeByPlanetId(Map<String, dynamic> root) {
  final out = <int, bool>{};
  final data = _asMap(root['data']);
  final list = _asList(data?['planet_position']);
  for (final item in list) {
    final map = _asMap(item);
    if (map == null) continue;
    final id = _parseInt(map['id']);
    if (id == null) continue;
    out[id] = _parseBool(map['is_retrograde']);
  }
  return out;
}

int? _parseAscendantSignFromPlanetPosition(Map<String, dynamic> root) {
  final data = _asMap(root['data']);
  final list = _asList(data?['planet_position']);
  for (final item in list) {
    final map = _asMap(item);
    if (map == null) continue;
    final id = _parseInt(map['id']);
    if (id != 100) continue;
    final position = _parseInt(map['position']);
    if (position != null && position >= 1 && position <= 12) return position;
    final rasiId0 = _parseInt(_asMap(map['rasi'])?['id']);
    if (rasiId0 != null && rasiId0 >= 0 && rasiId0 <= 11) return rasiId0 + 1;
  }
  return null;
}

int? _parseAscendantSignFromDivisional(Map<String, dynamic> root) {
  final data = _asMap(root['data']);
  final houses = _asList(data?['divisional_positions']);
  for (final h in houses) {
    final houseMap = _asMap(h);
    if (houseMap == null) continue;
    final planets = _asList(houseMap['planet_positions']);
    for (final p in planets) {
      final pMap = _asMap(p);
      if (pMap == null) continue;
      final planetId = _parseInt(_asMap(pMap['planet'])?['id']);
      if (planetId != 100) continue;
      final rasiId0 = _parseInt(_asMap(pMap['rasi'])?['id']);
      if (rasiId0 != null && rasiId0 >= 0 && rasiId0 <= 11) return rasiId0 + 1;
    }
  }
  return null;
}

void _fillFromDivisional(
  Map<String, dynamic> root, {
  required Map<int, bool> retroById,
  required List<ZodiacSign?> houseSigns,
  required List<List<KundaliPlanet>> housePlanets,
}) {
  final data = _asMap(root['data']);
  final houses = _asList(data?['divisional_positions']);

  for (final h in houses) {
    final houseMap = _asMap(h);
    if (houseMap == null) continue;

    final houseNumber = _parseInt(_asMap(houseMap['house'])?['number']);
    if (houseNumber == null || houseNumber < 1 || houseNumber > 12) continue;

    final houseRasiId0 = _parseInt(_asMap(houseMap['rasi'])?['id']);
    final houseSign = houseRasiId0 == null
        ? null
        : ZodiacSign.fromId(houseRasiId0 + 1);
    if (houseSign != null) houseSigns[houseNumber - 1] = houseSign;

    final planets = _asList(houseMap['planet_positions']);
    for (final p in planets) {
      final pMap = _asMap(p);
      if (pMap == null) continue;

      final prokeralaPlanetId = _parseInt(_asMap(pMap['planet'])?['id']);
      if (prokeralaPlanetId == null) continue;
      if (prokeralaPlanetId == 100) continue; // Ascendant is not a planet.

      final planetId = PlanetId.fromProkeralaId(prokeralaPlanetId);
      if (planetId == null) continue;

      final planetHouseNumber = _parseInt(_asMap(pMap['house'])?['number']);
      if (planetHouseNumber == null ||
          planetHouseNumber < 1 ||
          planetHouseNumber > 12) {
        continue;
      }

      final rasiId0 = _parseInt(_asMap(pMap['rasi'])?['id']);
      final sign = rasiId0 == null ? null : ZodiacSign.fromId(rasiId0 + 1);
      if (sign == null) continue;

      housePlanets[planetHouseNumber - 1].add(
        KundaliPlanet(
          id: planetId,
          sign: sign,
          house: planetHouseNumber,
          isRetrograde: retroById[prokeralaPlanetId] ?? false,
        ),
      );
    }
  }
}

List<dynamic> _asList(Object? raw) {
  if (raw is List) return raw;
  return const <dynamic>[];
}

Map<String, dynamic>? _asMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

int? _parseInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is double) return raw.round();
  if (raw is String) return int.tryParse(raw.trim());
  return null;
}

bool _parseBool(Object? raw) {
  if (raw == null) return false;
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) {
    final v = raw.trim().toLowerCase();
    return v == 'true' || v == '1' || v == 'yes';
  }
  return false;
}
