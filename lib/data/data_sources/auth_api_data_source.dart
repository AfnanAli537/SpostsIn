// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/generated/l10n.dart';
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
  final s = S.of(context);

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
  Future<void> logout() async {
  }

  @override
  Future<Map<String,dynamic>?> getCachedUser() async {
    return null; 
  }
    
    @override
  Future<bool> registerUser(UserModel user) async {
    final hasConnection = await NetworkChecker.hasInternetConnection();
    if (!hasConnection) throw Exception('No Internet Connection');

    try {
      final endpoint = getEndpointForUserType(user.userType);
      final data = await compute(buildRequestBodyIsolate, user);

      final response = await apiClient.post(endpoint, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('isSuccess')) {
          final isSuccess = responseData['isSuccess'] == true;

          if (isSuccess) return true;

          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            throw Exception(errors.join(', '));
          }

          throw Exception(responseData['message'] ?? 'Unknown registration error.');
        }
        return true;
      }

      //Non-success HTTP code (e.g. 400, 500)
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      // throw ApiErrorHandler.handleStatusCode(response.statusCode);
    } on DioException catch (dioError) {
      debugPrint("Dio exception: ${dioError.response?.data}");

      final data = dioError.response?.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is List && errors.isNotEmpty) {
            throw Exception(errors.join(', '));
          }
        }
        if (data.containsKey('message')) {
          throw Exception(data['message']);
        }
      }

      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
      debugPrint("Unknown exception: $e");
      throw ApiErrorHandler.handleUnknownErrorKey(e);
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
