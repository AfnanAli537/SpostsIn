// // ignore_for_file: use_build_context_synchronously

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:sports_in/core/error/api_error_handler.dart';
// import 'package:sports_in/core/network/api_client.dart';
// import 'package:sports_in/core/network/endpoints.dart';
// import 'package:sports_in/core/network/network_checker.dart';
// import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
// import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
// import 'package:sports_in/data/models/login_response_model.dart';
// import 'package:sports_in/data/models/user_model.dart';
// import 'package:sports_in/generated/l10n.dart';
// import '../interfaces/i_auth_data_source.dart';

// class AuthApiDataSource implements IAuthDataSource {
//   final ApiClient apiClient;
//   AuthApiDataSource(this.apiClient);

//   // @override
//   // Future<LoginResponse> login({
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   final hasConnection = await NetworkChecker.hasInternetConnection();
//   //   if (!hasConnection) throw Exception('No Internet Connection');
//   // try {
//   //     final response = await apiClient.post(
//   //       Endpoints.login, 
//   //       data: {
//   //         'email': email,
//   //         'password': password,
//   //       },
//   //     );
//   //     if (response.statusCode == 200 && response.data != null) {
//   //       return LoginResponse.fromJson(response.data);
//   //     } else {
//   //       throw ApiErrorHandler.handleStatusCode(response.statusCode);
//   //     }
//   //   } on DioException catch (dioError) {
//   //     throw ApiErrorHandler.handleDioError(context,dioError);
//   //   } catch (e) {
//   //     throw ApiErrorHandler.handleUnknownError(e);
//   //   }
//   // }

// @override
// Future<LoginResponse> login({
//   required BuildContext context,
//   required String email,
//   required String password,
// }) async {
//   final s = S.of(context);

//   // final hasConnection = await NetworkChecker.hasInternetConnection();
//   // if (!hasConnection) throw Exception(s.noInternetConnection);

//   try {
//     final response = await apiClient.post(
//       Endpoints.login,
//       data: {
//         'email': email,
//         'password': password,
//       },
//     );

//     if (response.statusCode == 200 && response.data != null) {
//       return LoginResponse.fromJson(response.data);
//     } 
//     else {
//       throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
//     }
//   } 
//   on DioException catch (dioError) {
//     throw ApiErrorHandler.handleDioErrorKey(dioError);
//   }
//   catch (e) {
//   //   final key = ApiErrorHandler.handleErrorKey(e);
//   // throw Exception(key);
//     throw ApiErrorHandler.handleUnknownErrorKey(e);
//   }
// }

//   @override
//   Future<void> logout() async {
//   }

//   @override
//   Future<Map<String,dynamic>?> getCachedUser() async {
//     return null; 
//   }
    
//     @override
//   Future<bool> registerUser(UserModel user) async {
//     final hasConnection = await NetworkChecker.hasInternetConnection();
//     if (!hasConnection) throw Exception('No Internet Connection');

//     try {
//       final endpoint = getEndpointForUserType(user.userType);
//       final data = await compute(buildRequestBodyIsolate, user);

//       final response = await apiClient.post(endpoint, data: data);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = response.data;

//         if (responseData is Map<String, dynamic> &&
//             responseData.containsKey('isSuccess')) {
//           final isSuccess = responseData['isSuccess'] == true;

//           if (isSuccess) return true;

//           final errors = responseData['errors'];
//           if (errors is List && errors.isNotEmpty) {
//             throw Exception(errors.join(', '));
//           }

//           throw Exception(responseData['message'] ?? 'Unknown registration error.');
//         }
//         return true;
//       }

//       //Non-success HTTP code (e.g. 400, 500)
//       throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
//       // throw ApiErrorHandler.handleStatusCode(response.statusCode);
//     } on DioException catch (dioError) {
//       debugPrint("Dio exception: ${dioError.response?.data}");

//       final data = dioError.response?.data;
//       if (data is Map<String, dynamic>) {
//         if (data.containsKey('errors')) {
//           final errors = data['errors'];
//           if (errors is List && errors.isNotEmpty) {
//             throw Exception(errors.join(', '));
//           }
//         }
//         if (data.containsKey('message')) {
//           throw Exception(data['message']);
//         }
//       }

//       throw ApiErrorHandler.handleDioErrorKey(dioError);
//     } catch (e) {
//       debugPrint("Unknown exception: $e");
//       throw ApiErrorHandler.handleUnknownErrorKey(e);
//     }
//   }
//   @override
//   Future<bool> sendOtp({required String email}) async {
//   final response = await apiClient.post(Endpoints.sendOtp, data: {'email': email});
//   return response.statusCode == 200;
// }
//   @override
// Future<bool> verifyOtp({ required String email,required String otp}) async {
//   final response = await apiClient.post(Endpoints.verifyOtp, data: {
//     'email': email,
//     'otp': otp,
//   });
//   return response.statusCode == 200;
// }
//   @override
// Future<bool> resetPassword({required String email,required String newPassword,required String confirmPassword}) async {
//   final response = await apiClient.post(Endpoints.resetPassword, data: {
//     'email': email,
//     'newPassword': newPassword,
//     'confirmPassword': confirmPassword,
//   });
//   return response.statusCode == 200;
// }

// }

// ignore_for_file: use_build_context_synchronously

// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';
// import 'package:sports_in/generated/l10n.dart';
import '../interfaces/i_auth_data_source.dart';

class AuthApiDataSource implements IAuthDataSource {
  final ApiClient apiClient;
  AuthApiDataSource(this.apiClient);

  // @override
  // Future<LoginResponse> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final hasConnection = await NetworkChecker.hasInternetConnection();
  //   if (!hasConnection) throw Exception('No Internet Connection');
  // try {
  //     final response = await apiClient.post(
  //       Endpoints.login, 
  //       data: {
  //         'email': email,
  //         'password': password,
  //       },
  //     );
  //     if (response.statusCode == 200 && response.data != null) {
  //       return LoginResponse.fromJson(response.data);
  //     } else {
  //       throw ApiErrorHandler.handleStatusCode(response.statusCode);
  //     }
  //   } on DioException catch (dioError) {
  //     throw ApiErrorHandler.handleDioError(context,dioError);
  //   } catch (e) {
  //     throw ApiErrorHandler.handleUnknownError(e);
  //   }
  // }

@override
Future<LoginResponse> login({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  // final s = S.of(context);

  // final hasConnection = await NetworkChecker.hasInternetConnection();
  // if (!hasConnection) throw Exception(s.noInternetConnection);

  try {
    final response = await apiClient.post(
      Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      return LoginResponse.fromJson(response.data);
    } 
    else {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }
  } 
  on DioException catch (dioError) {
    throw ApiErrorHandler.handleDioErrorKey(dioError);
  }
  catch (e) {
  //   final key = ApiErrorHandler.handleErrorKey(e);
  // throw Exception(key);
    throw ApiErrorHandler.handleUnknownErrorKey(e);
  }
}

  @override
  Future<void> logout() async {}

  @override
  Future<Map<String, dynamic>?> getCachedUser() async {
    return null;
  }
@override
Future<bool> registerUser(UserModel user) async {
  final hasConnection = await NetworkChecker.hasInternetConnection();
  
  if (!hasConnection) {
    debugPrint("========connection error: no internet=========");
    throw ApiException(
      message: 'No Internet Connection',
      key: StringKeys.noInternetConnection,
    );
  }

  try {
    final endpoint = getEndpointForUserType(user.userType);
        debugPrint("========${user}=========");

    final data = buildRequestBodyIsolate(user);

    final response = await apiClient.post(endpoint, data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData['isSuccess'] == true) {
        return true;
      }
      throw ApiException(
        message: responseData?['message'] ?? 'Registration failed',
        key: StringKeys.validationError,
      );
    }

    // Non-success status code
    throw ApiException(
      message: 'Server responded with code ${response.statusCode}',
      key: ApiErrorHandler.handleStatusCodeKey(response.statusCode, isRegister: true),
    );
    
  } on DioException catch (dioError) {

    // Parse the response data for specific errors
    final data = dioError.response?.data;
    if (data is Map<String, dynamic>) {
      String? errorMessage;
      String errorKey = StringKeys.validationError;

      // Check errors array
      if (data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          errorMessage = errors.join(', ');
          
          // Check if it's email already exists error
          final errorString = errorMessage.toLowerCase();
          if (errorString.contains('email') && 
              (errorString.contains('exist') || 
               errorString.contains('already'))) {
            errorKey = StringKeys.emailAlreadyExists;
          }
        }
      }

      // Check message field
      if (errorMessage == null && data['message'] != null) {
        errorMessage = data['message'].toString();
      }

      if (errorMessage != null) {
        throw ApiException(
          message: errorMessage,
          key: errorKey,
        );
      }
    }

    // Fallback to generic Dio error handling
    final key = ApiErrorHandler.handleDioErrorKey(dioError, isRegister: true);
    throw ApiException(
      message: dioError.message ?? 'Request failed',
      key: key,
    );
    
  } catch (e) {    
    // If it's already ApiException, rethrow it
    if (e is ApiException) rethrow;
    
    throw ApiException(
      message: e.toString(),
      key: StringKeys.unexpectedError,
    );
  }
}
  @override
  Future<bool> sendOtp({required String email}) async {
  final response = await apiClient.post(Endpoints.sendOtp, data: {'email': email});
  return response.statusCode == 200;
}
  @override
Future<bool> verifyOtp({ required String email,required String otp}) async {
  final response = await apiClient.post(Endpoints.verifyOtp, data: {
    'email': email,
    'otp': otp,
  });
  return response.statusCode == 200;
}
  @override
Future<bool> resetPassword({required String email,required String newPassword,required String confirmPassword}) async {
  final response = await apiClient.post(Endpoints.resetPassword, data: {
    'email': email,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  });
  return response.statusCode == 200;
}

}