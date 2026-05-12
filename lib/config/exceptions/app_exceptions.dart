class AppException implements Exception {
  final String message;
  final String? debugMessage;
  final String? code;
  final StackTrace? stackTrace;
  final ExceptionType type;

  AppException({
    required this.message,
    this.debugMessage,
    this.code,
    this.stackTrace,
    this.type = ExceptionType.generic,
  });

  @override
  String toString() {
    return '${type.name}Exception: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

enum ExceptionType { api, network, localStorage, generic }
