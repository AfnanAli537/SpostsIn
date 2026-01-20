import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
import 'package:sports_in/features/register/models/user_model.dart';
import '../interfaces/i_auth_data_source.dart';
@LazySingleton(as: IAuthDataSource)
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
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
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
  Future<LoginResponse> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
            '101794351369-sdsjn89f50e4mhth41bfaa6qtctb7kf9.apps.googleusercontent.com',
      );
      await googleSignIn.signOut();
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw Exception('User cancelled Google Sign-In');
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      print("token ==========================$idToken");
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google ID Token missing');
      }
      final response = await apiClient.post(
        Endpoints.googleSignUp,
        data: {'IdToken': idToken},
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
      throw ApiErrorHandler.handleUnknownErrorKey(e);
    }
  }

@override
  Future<bool> registerUser(UserModel user) async {
    final hasConnection = await NetworkChecker.hasInternetConnection();

    if (!hasConnection) {
      throw ApiException(
        message: 'No Internet Connection',
        key: StringKeys.noInternetConnection,
      );
    }

    try {
      final endpoint = getEndpointForUserType(user.userType);
      final data = await buildRequestBodyIsolate(user);

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

      throw ApiException(
        message: 'Server responded with code ${response.statusCode}',
        key: ApiErrorHandler.handleStatusCodeKey(
          response.statusCode,
          isRegister: true,
        ),
      );
    } on DioException catch (dioError) {
      final data = dioError.response?.data;
      if (data is Map<String, dynamic>) {
        String? errorMessage;
        String errorKey = StringKeys.validationError;

        if (data['errors'] is List) {
          final errors = data['errors'] as List;
          if (errors.isNotEmpty) {
            errorMessage = errors.join(', ');

            final errorString = errorMessage.toLowerCase();
            if (errorString.contains('email') &&
                (errorString.contains('exist') ||
                    errorString.contains('already'))) {
              errorKey = StringKeys.emailAlreadyExists;
            }
          }
        }

        if (errorMessage == null && data['message'] != null) {
          errorMessage = data['message'].toString();
        }

        if (errorMessage != null) {
          throw ApiException(message: errorMessage, key: errorKey);
        }
      }

      final key = ApiErrorHandler.handleDioErrorKey(dioError, isRegister: true);
      throw ApiException(
        message: dioError.message ?? 'Request failed',
        key: key,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      throw ApiException(
        message: e.toString(),
        key: StringKeys.unexpectedError,
      );
    }
  }

  @override
  Future<bool> sendOtp({required String email}) async {
    try {
      final response = await apiClient.post(
        Endpoints.sendOtp,
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
      throw ApiErrorHandler.handleUnknownErrorKey(e);
    }
  }

  @override
  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await apiClient.post(
        Endpoints.verifyOtp,
        data: {'email': email, 'code': otp},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
      throw ApiErrorHandler.handleUnknownErrorKey(e);
    }
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiClient.post(
        Endpoints.resetPassword,
        data: {
          'email': email,
          'code': otp,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioErrorKey(dioError);
    } catch (e) {
      throw ApiErrorHandler.handleUnknownErrorKey(e);
    }
  }
}
