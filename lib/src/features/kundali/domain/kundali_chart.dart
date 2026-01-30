enum PlanetId {
  sun('Su', 'Sun'),
  moon('Mo', 'Moon'),
  mars('Ma', 'Mars'),
  mercury('Me', 'Mercury'),
  jupiter('Ju', 'Jupiter'),
  venus('Ve', 'Venus'),
  saturn('Sa', 'Saturn'),
  rahu('Ra', 'Rahu'),
  ketu('Ke', 'Ketu');

  const PlanetId(this.abbr, this.displayName);
  final String abbr;
  final String displayName;

  static PlanetId? fromApiName(String raw) {
    final n = raw.trim().toLowerCase();
    return switch (n) {
      'sun' => PlanetId.sun,
      'moon' => PlanetId.moon,
      'mars' => PlanetId.mars,
      'mercury' => PlanetId.mercury,
      'jupiter' => PlanetId.jupiter,
      'venus' => PlanetId.venus,
      'saturn' => PlanetId.saturn,
      'rahu' => PlanetId.rahu,
      'ketu' => PlanetId.ketu,
      _ => null,
    };
  }

  static PlanetId? fromProkeralaId(int id) {
    return switch (id) {
      0 => PlanetId.sun,
      1 => PlanetId.moon,
      2 => PlanetId.mercury,
      3 => PlanetId.venus,
      4 => PlanetId.mars,
      5 => PlanetId.jupiter,
      6 => PlanetId.saturn,
      101 => PlanetId.rahu,
      102 => PlanetId.ketu,
      _ => null,
    };
  }
}

enum ZodiacSign {
  aries(1, 'Aries', 'Ar'),
  taurus(2, 'Taurus', 'Ta'),
  gemini(3, 'Gemini', 'Ge'),
  cancer(4, 'Cancer', 'Ca'),
  leo(5, 'Leo', 'Le'),
  virgo(6, 'Virgo', 'Vi'),
  libra(7, 'Libra', 'Li'),
  scorpio(8, 'Scorpio', 'Sc'),
  sagittarius(9, 'Sagittarius', 'Sg'),
  capricorn(10, 'Capricorn', 'Cp'),
  aquarius(11, 'Aquarius', 'Aq'),
  pisces(12, 'Pisces', 'Pi');

  const ZodiacSign(this.id, this.displayName, this.shortName);
  final int id;
  final String displayName;
  final String shortName;

  static ZodiacSign? fromId(int id) {
    for (final s in ZodiacSign.values) {
      if (s.id == id) return s;
    }
    return null;
  }

  static ZodiacSign? fromApiValue(Object? value) {
    if (value == null) return null;

    if (value is int) return ZodiacSign.fromId(value);
    if (value is double) return ZodiacSign.fromId(value.round());

    if (value is String) {
      final v = value.trim().toLowerCase();
      // Some APIs return sign name, others return a number as a string.
      final asInt = int.tryParse(v);
      if (asInt != null) return ZodiacSign.fromId(asInt);

      return switch (v) {
        'aries' => ZodiacSign.aries,
        'taurus' => ZodiacSign.taurus,
        'gemini' => ZodiacSign.gemini,
        'cancer' => ZodiacSign.cancer,
        'leo' => ZodiacSign.leo,
        'virgo' => ZodiacSign.virgo,
        'libra' => ZodiacSign.libra,
        'scorpio' => ZodiacSign.scorpio,
        'sagittarius' => ZodiacSign.sagittarius,
        'capricorn' => ZodiacSign.capricorn,
        'aquarius' => ZodiacSign.aquarius,
        'pisces' => ZodiacSign.pisces,
        _ => null,
      };
    }

    if (value is Map) {
      final v = value['sign'] ?? value['id'] ?? value['sign_id'];
      return ZodiacSign.fromApiValue(v);
    }

    return null;
  }
}

class KundaliPlanet {
  const KundaliPlanet({
    required this.id,
    required this.sign,
    required this.house,
    this.degree,
    this.isRetrograde = false,
  });

  final PlanetId id;
  final ZodiacSign sign;
  final int house;
  final double? degree;
  final bool isRetrograde;
}

class KundaliHouse {
  KundaliHouse({
    required this.number,
    required this.sign,
    required List<KundaliPlanet> planets,
  }) : planets = List<KundaliPlanet>.unmodifiable(planets);

  final int number;
  final ZodiacSign sign;
  final List<KundaliPlanet> planets;
}

class KundaliChartData {
  KundaliChartData({
    required this.ascendant,
    required List<KundaliHouse> houses,
  }) : houses = List<KundaliHouse>.unmodifiable(houses);

  final ZodiacSign ascendant;
  final List<KundaliHouse> houses;
}
