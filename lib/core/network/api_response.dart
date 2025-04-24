import 'dart:convert';

import '../errors/exceptions.dart';

/// A utility class to handle API responses
class ApiResponse {
  /// Check if the response is successful
  static bool isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Handle response body based on status code
  static T handleResponse<T>(
    int statusCode,
    String responseBody,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (isSuccessful(statusCode)) {
      try {
        return fromJson(json.decode(responseBody));
      } catch (e) {
        throw const ServerException(
          'Failed to parse response',
          code: 'parse_error',
        );
      }
    } else {
      throw _handleErrorResponse(statusCode, responseBody);
    }
  }

  /// Create appropriate exception based on error response
  static AppException _handleErrorResponse(
    int statusCode,
    String responseBody,
  ) {
    try {
      final Map<String, dynamic> errorData = json.decode(responseBody);

      if (statusCode == 401 || statusCode == 403) {
        return AppAuthException(
          errorData['message'] ?? 'Authentication failed',
          code: errorData['code'] ?? 'auth_error',
        );
      } else if (statusCode == 422) {
        return ValidationException(
          errorData['message'] ?? 'Validation failed',
          code: errorData['code'] ?? 'validation_error',
          errors: _parseValidationErrors(errorData),
        );
      } else {
        return ServerException(
          errorData['message'] ?? 'Server error',
          code: errorData['code'] ?? 'server_error',
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return ServerException(
        'Server error',
        code: 'server_error',
        statusCode: statusCode,
      );
    }
  }

  /// Parse validation errors from API response
  static Map<String, List<String>>? _parseValidationErrors(
    Map<String, dynamic> errorData,
  ) {
    final errors = errorData['errors'];
    if (errors is Map<String, dynamic>) {
      final result = <String, List<String>>{};
      errors.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          result[key] = [value];
        }
      });
      return result;
    }
    return null;
  }
}
