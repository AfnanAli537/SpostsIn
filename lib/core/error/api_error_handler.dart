// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:sports_in/generated/l10n.dart';

// class ApiErrorHandler {
//   static Exception handleDioError(BuildContext context, DioException error) {
//     final s = S.of(context);

//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.receiveTimeout:
//       case DioExceptionType.sendTimeout:
//         return Exception(s.connectionTimedOut);

//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         final data = error.response?.data;

//         String message = s.unexpectedError;
//         if (data is Map<String, dynamic>) {
//           // Handle multiple backend error styles
//           if (data['errors'] != null && data['errors'] is List && data['errors'].isNotEmpty) {
//             message = data['errors'].first.toString();
//           } else if (data['message'] != null) {
//             message = data['message'].toString();

//             // Replace vague backend messages
//             if (message.contains('validation') || message.contains('occurred')) {
//               message = _friendlyMessageForStatus(context, statusCode);
//             }
//           }
//         }

//         return Exception(message);

//       case DioExceptionType.cancel:
//         return Exception(s.requestCancelled);

//       default:
//         return Exception(s.somethingWentWrong);
//     }
//   }

//   static String _friendlyMessageForStatus(BuildContext context, int? statusCode) {
//     final s = S.of(context);
//     switch (statusCode) {
//       case 400:
//         return s.invalidEmailOrPassword;
//       case 401:
//         return s.unauthorized;
//       case 404:
//         return s.resourceNotFound;
//       case 500:
//         return s.serverError;
//       default:
//         return s.unexpectedError;
//     }
//   }

//   static Exception handleStatusCode(BuildContext context, int? statusCode) {
//     return Exception(_friendlyMessageForStatus(context, statusCode));
//   }

//   static Exception handleUnknownError(BuildContext context, Object e) {
//     final s = S.of(context);
//     return Exception(s.unexpectedError);
//   }
// }



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
class ApiException implements Exception {
  final String message;
  final String key;

  ApiException({required this.message, required this.key});

  @override
  String toString() => key; // Return key instead of message for proper handling
}
class ApiErrorHandler {
  /// Returns a localization key for the error.
  //  static String handleErrorKey(Object error) {
  //   // 🌐 Handle your custom no-internet or general network errors
  //   if (error is SocketException) {
  //     return StringKeys.noInternetConnection;
  //   }
  //   if (error is DioException) {
  //     return handleDioErrorKey(error);
  //   }
  //   // For anything else
  //   return StringKeys.unexpectedError;
  // }
  
   static String handleDioErrorKey(DioException error, {bool isRegister=false}) {
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
        // final data = error.response?.data;
        // String key = StringKeys.unexpectedError;
        // if (data is Map<String, dynamic>) {
          // if (data['errors'] != null &&
          //     data['errors'] is List &&
          //     data['errors'].isNotEmpty) {
          //   key = StringKeys.validationError;
          // } else if (data['message'] != null) {
          //   final message = data['message'].toString();
          //   if (message.contains('validation') ||
          //       message.contains('occurred')) {
          //     key = _keyForStatus(statusCode);
          //   } else {
         final   String key = _keyForStatus(statusCode);
        //     }
        //   }
        // }
      // print(key);
        return key;
      case DioExceptionType.cancel:
        return StringKeys.requestCancelled;

      default:
        return error.response as String;
    }
  }

  static String _keyForStatus(int? statusCode,  {bool isRegister=false}) {
    switch (statusCode) {
      case 400:
        return isRegister == true? StringKeys.emailAlreadyExists: StringKeys.invalidEmailOrPassword;
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

  static String handleStatusCodeKey(int? statusCode,  {bool isRegister=false}) {
    return _keyForStatus(statusCode, isRegister: isRegister);
  }

  static String handleUnknownErrorKey(Object e) {
    return StringKeys.unexpectedError;
  }
}
