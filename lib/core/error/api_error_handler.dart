import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class ApiException implements Exception {
  final String message;
  final String key;

  ApiException({required this.message, required this.key});

  @override
  String toString() => message;
}

class ApiErrorHandler {
  static ApiException handleDioError(DioException error) {
    if (error.error is SocketException) {
      return ApiException(
        message: 'No internet connection',
        key: StringKeys.noInternetConnection,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Connection timed out',
          key: StringKeys.connectionTimedOut,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          key: StringKeys.requestCancelled,
        );
      default:
        return ApiException(
          message: 'Unexpected error',
          key: StringKeys.unexpectedError,
        );
    }
  }

  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final rawData = error.response?.data;

    // Parse body — Dio may return it as String or Map
    Map<String, dynamic>? body;
    if (rawData is Map<String, dynamic>) {
      body = rawData;
    } else if (rawData is String && rawData.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {}
    }

    // Priority: errors[0] → message → status code fallback
    String? serverMessage;
    if (body != null) {
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty) {
        serverMessage = errors.first.toString();
      } else if (body['message'] != null &&
          body['message'].toString().trim().isNotEmpty) {
        serverMessage = body['message'].toString();
      }
    }

    final fallbackKey = _keyForStatus(statusCode);

    return ApiException(
      message: serverMessage ?? fallbackKey,
      key: fallbackKey,
    );
  }

  static String _keyForStatus(int? statusCode) {
    switch (statusCode) {
      case 400: return StringKeys.badRequest;
      case 401: return StringKeys.unauthorized;
      case 403: return StringKeys.forbidden;
      case 404: return StringKeys.resourceNotFound;
      case 409: return StringKeys.conflict;
      case 422: return StringKeys.validationError;
      case 500: return StringKeys.serverError;
      case 503: return StringKeys.serviceUnavailable;
      default:  return StringKeys.unexpectedError;
    }
  }
}