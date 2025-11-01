import 'package:dio/dio.dart';

class ApiErrorHandler {
  static Exception handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Unexpected error.';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }

  static Exception handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Exception('Invalid request.');
      case 401:
        return Exception('Unauthorized. Please check your credentials.');
      case 404:
        return Exception('Resource not found.');
      case 500:
        return Exception('Server error. Please try again later.');
      default:
        return Exception('Unexpected error occurred.');
    }
  }

  static Exception handleUnknownError(Object e) {
    return Exception('Unexpected error: $e');
  }
}
