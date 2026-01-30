class PlaceSuggestion {
  const PlaceSuggestion({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.timezone,
  });

  final String name;
  final double latitude;
  final double longitude;

  final String? country;
  final String? admin1;
  final String? timezone;

  String label() {
    final parts = <String>[name.trim()];
    final a1 = admin1?.trim();
    if (a1 != null && a1.isNotEmpty) parts.add(a1);
    final c = country?.trim();
    if (c != null && c.isNotEmpty) parts.add(c);
    return parts.join(', ');
  }
}
