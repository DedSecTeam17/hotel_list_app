class AppConfig {
  static const bool isMock = true;
  static const String baseUrl = isMock
      ? 'https://mockapi.io/assets'
      : 'https://api.yourproductionserver.com';
  static const Duration requestTimeout = Duration(seconds: 10);
}
