class ProkeralaApiConfig {
  const ProkeralaApiConfig({
    required this.baseUrl,
    required this.tokenUrl,
    required this.clientId,
    required this.clientSecret,
    required this.ayanamsa,
    required this.language,
    required this.chartType,
  });

  factory ProkeralaApiConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'PROKERALA_BASE_URL',
      defaultValue: 'https://api.prokerala.com/v2',
    );
    const tokenUrl = String.fromEnvironment(
      'PROKERALA_TOKEN_URL',
      defaultValue: 'https://api.prokerala.com/token',
    );
    const clientId = String.fromEnvironment('PROKERALA_CLIENT_ID');
    const clientSecret = String.fromEnvironment('PROKERALA_CLIENT_SECRET');
    const ayanamsa = int.fromEnvironment('PROKERALA_AYANAMSA', defaultValue: 1);
    const language = String.fromEnvironment(
      'PROKERALA_LANG',
      defaultValue: 'en',
    );
    const chartType = String.fromEnvironment(
      'PROKERALA_CHART_TYPE',
      defaultValue: 'lagna',
    );

    return const ProkeralaApiConfig(
      baseUrl: baseUrl,
      tokenUrl: tokenUrl,
      clientId: clientId,
      clientSecret: clientSecret,
      ayanamsa: ayanamsa,
      language: language,
      chartType: chartType,
    );
  }

  final String baseUrl;
  final String tokenUrl;
  final String clientId;
  final String clientSecret;
  final int ayanamsa;
  final String language;
  final String chartType;

  bool get isConfigured =>
      clientId.trim().isNotEmpty && clientSecret.trim().isNotEmpty;
}
