import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/strings_keys.dart';

class ApiException implements Exception {
  final String message;
  final String key;

  ApiException({required this.message, required this.key});

  @override
  String toString() => key; 
}

class ApiErrorHandler {
  static String handleDioErrorKey(DioException error, {bool isRegister = false}) {
    if (error.error is SocketException) {
      return StringKeys.noInternetConnection;
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return StringKeys.connectionTimedOut;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final String key = _keyForStatus(statusCode, isRegister: isRegister);

        return key;
      case DioExceptionType.cancel:
        return StringKeys.requestCancelled;

      default:
        return StringKeys.unexpectedError;
    }
  }

  static String _keyForStatus(int? statusCode, {bool isRegister = false}) {
    switch (statusCode) {
      case 400:
        return isRegister == true 
            ? StringKeys.emailAlreadyExists 
            : StringKeys.invalidEmailOrPassword;
      case 401:
        return StringKeys.unauthorized;
      case 404:
        return StringKeys.resourceNotFound;
      case 500:
        return StringKeys.serverError;
      case 503:
        return StringKeys.serviceUnavailable;
      default:
        return StringKeys.unexpectedError;
    }
  }

  static String handleStatusCodeKey(int? statusCode, {bool isRegister = false}) {
    return _keyForStatus(statusCode, isRegister: isRegister);
  }

  static String handleUnknownErrorKey(Object e) {
    return StringKeys.unexpectedError;
  }
}