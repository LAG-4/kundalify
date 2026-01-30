class BirthTime {
  const BirthTime({required this.hour, required this.minute});

  final int hour;
  final int minute;

  String format24h() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class BirthDetails {
  const BirthDetails({
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  /// Local calendar date (year/month/day).
  final DateTime date;
  final BirthTime time;
  final double latitude;
  final double longitude;

  /// UTC offset in hours, e.g. `5.5` for IST.
  final double timezone;

  int get day => date.day;
  int get month => date.month;
  int get year => date.year;
  int get hour => time.hour;
  int get minute => time.minute;

  DateTime get localDateTime => DateTime(year, month, day, hour, minute);

  /// Prokerala expects coordinates as "lat,lon".
  String toProkeralaCoordinates() {
    final lat = latitude.toStringAsFixed(6);
    final lon = longitude.toStringAsFixed(6);
    return '$lat,$lon';
  }

  /// Prokerala expects ISO 8601 datetime with offset, e.g. 2004-02-12T15:19:21+05:30.
  ///
  /// IMPORTANT: when used as a query parameter, the "+" must be URL-encoded.
  String toProkeralaDateTime() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final offset = _formatUtcOffset(timezone);
    return '$y-$m-$d'
        'T'
        '$hh:$mm:00$offset';
  }

  /// Payload used by common Vedic astrology APIs (AstrologyAPI/VedicRishi style).
  Map<String, Object?> toApiPayload() {
    return <String, Object?>{
      'day': day,
      'month': month,
      'year': year,
      'hour': hour,
      'min': minute,
      'lat': latitude,
      'lon': longitude,
      'tzone': timezone,
    };
  }
}

String _formatUtcOffset(double hours) {
  final totalMinutes = (hours * 60).round();
  final sign = totalMinutes >= 0 ? '+' : '-';
  final absMinutes = totalMinutes.abs();
  final hh = (absMinutes ~/ 60).toString().padLeft(2, '0');
  final mm = (absMinutes % 60).toString().padLeft(2, '0');
  return '$sign$hh:$mm';
}
