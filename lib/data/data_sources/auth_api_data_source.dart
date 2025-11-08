// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';
import '../interfaces/i_auth_data_source.dart';

class AuthApiDataSource implements IAuthDataSource {
  final ApiClient apiClient;
  AuthApiDataSource(this.apiClient);

@override
Future<LoginResponse> login({
  required BuildContext context,
  required String email,
  required String password,
}) async {
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


Future<LoginResponse> loginWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // Optional: force account picker
    await googleSignIn.signOut();

    // Show account picker
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('User cancelled Google Sign-In');
    }

    // Get ID token
    final auth = await account.authentication;
    final idToken = auth.idToken;
    print("Google ID Token: $idToken");
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Google ID Token missing');
    }

    // Send token to backend
    final response = await apiClient.post(
      Endpoints.googleSignUp,
      data: {'token': idToken},
    );
print("Sending to backend: ${{'token': idToken}}");
print("Backend response: ${response.data}");
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
    }
  } on DioException catch (dioError) {
    throw ApiErrorHandler.handleDioErrorKey(dioError);
  } catch (e) {
    throw e; // BLoC will handle failure toast
  }
}

  //  @override 

  //   Future<LoginResponse> loginWithGoogle() async {
  //   try {
  //     // Step 1: Initialize Google Sign-In
  //     await GoogleSignIn.instance.initialize();

  //     // Step 2: Open Google account picker
  //     final result = await GoogleSignIn.instance.authenticate(
  //       scopeHint: ['email', 'profile'],
  //     );

  //     // Step 3: Get ID token
  //     final idToken = result.authentication.idToken;
  //     if (idToken == null || idToken.isEmpty) {
  //       throw Exception('Google ID Token missing');
  //     }

  //     // Step 4: Send token to backend
  //     final response = await apiClient.post(
  //       Endpoints.googleSignUp,
  //       data: {'token': idToken},
  //     );

  //     if (response.statusCode == 200) {
  //       return LoginResponse.fromJson(response.data);
  //     } else {
  //       throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
  //     }
  //   } on DioException catch (dioError) {
  //     throw ApiErrorHandler.handleDioErrorKey(dioError);
  //   } catch (e) {
  //     throw ApiErrorHandler.handleUnknownErrorKey(e);
  //   }
  // }

  @override
  Future<bool> registerUser(UserModel user) async {
    final hasConnection = await NetworkChecker.hasInternetConnection();
    if (!hasConnection) throw Exception('No Internet Connection');

    try {
      final endpoint = getEndpointForUserType(user.userType);
      final data = await compute(buildRequestBodyIsolate, user);
      // debugPrint("📤 Registering to $endpoint with data: $data");

      final response = await apiClient.post(endpoint, data: data);
      // debugPrint("📩 Response: ${response.statusCode} ${response.data}");

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
throw Exception("error");
      //Non-success HTTP code (e.g. 400, 500)
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
throw Exception("error");
      // throw ApiErrorHandler.handleDioError(dioError);
    } catch (e) {
      debugPrint("Unknown exception: $e");
      // throw ApiErrorHandler.handleUnknownError(e);
      throw Exception("error");
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
