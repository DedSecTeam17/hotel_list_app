class AppException implements Exception {
  final String message;
  final int code;

  AppException(this.message, [this.code = 500]);

  @override
  String toString() => 'AppException: $message (code $code)';
}
