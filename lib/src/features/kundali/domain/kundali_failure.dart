class KundaliFailure implements Exception {
  const KundaliFailure({
    required this.title,
    required this.message,
    this.details,
  });

  final String title;
  final String message;
  final String? details;

  @override
  String toString() {
    final d = details;
    if (d == null || d.isEmpty) return 'KundaliFailure($title): $message';
    return 'KundaliFailure($title): $message [$d]';
  }
}
