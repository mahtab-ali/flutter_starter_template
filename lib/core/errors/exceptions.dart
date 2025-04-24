/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  /// Creates a concrete instance of AppException from an error message
  factory AppException.fromError(String message, {String? code}) {
    return GenericException(message, code: code);
  }

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Generic exception for unclassified errors
class GenericException extends AppException {
  const GenericException(super.message, {super.code});
}

/// Exception for network-related errors
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Exception for server-related errors
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {super.code, this.statusCode});

  @override
  String toString() =>
      'ServerException: $message${code != null ? ' (Code: $code)' : ''}${statusCode != null ? ' [Status: $statusCode]' : ''}';
}

/// Exception for cache-related errors
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Exception for authentication-related errors
class AppAuthException extends AppException {
  const AppAuthException(super.message, {super.code});
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException(super.message, {super.code, this.errors});
}
