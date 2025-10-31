import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class AuthRepository {
  final Dio _dio;

  // Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-url.com/api';

  AuthRepository(this._dio) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  // ==================== PLAYER REGISTRATION ====================
  Future<Map<String, dynamic>?> registerPlayer({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/player/register',
        data: {
          'email': email,
          'password': password,
          'firstName': userData['firstName'],
          'lastName': userData['lastName'],
          'height': userData['height'],
          'weight': userData['weight'],
          'gender': userData['gender'],
          'location': userData['location'],
          'sportPosition': userData['sportPosition'],
          'position': userData['position'],
          'hasClub': userData['hasClub'] ?? false,
          'profileImage': userData['profileImage'], // Path or base64
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register player: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== COACH REGISTRATION ====================
  Future<Map<String, dynamic>?> registerCoach({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/coach/register',
        data: {
          'email': email,
          'password': password,
          'firstName': userData['firstName'],
          'lastName': userData['lastName'],
          'yearsOfExperience': userData['yearsOfExperience'],
          'sportName': userData['sportName'],
          'location': userData['location'],
          'gender': userData['gender'],
          'hasClub': userData['hasClub'] ?? false,
          'profileImage': userData['profileImage'],
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register coach: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== SCOUT REGISTRATION ====================
  Future<Map<String, dynamic>?> registerScout({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/scout/register',
        data: {
          'email': email,
          'password': password,
          ...userData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register scout: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== CLUB REGISTRATION ====================
  Future<Map<String, dynamic>?> registerClub({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/club/register',
        data: {
          'email': email,
          'password': password,
          ...userData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register club: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== INSTITUTE REGISTRATION ====================
  Future<Map<String, dynamic>?> registerInstitute({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/institute/register',
        data: {
          'email': email,
          'password': password,
          ...userData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register institute: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== OTHER REGISTRATION ====================
  Future<Map<String, dynamic>?> registerOther({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/other/register',
        data: {
          'email': email,
          'password': password,
          ...userData,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to register other: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== SIGN IN ====================
  Future<Map<String, dynamic>?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Store token if your API uses JWT
        final token = response.data['token'];
        if (token != null) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
          // TODO: Save token to secure storage (flutter_secure_storage)
        }
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("Failed to sign in: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== SIGN OUT ====================
  Future<void> signOut() async {
    try {
      await _dio.post('/auth/logout');
      _dio.options.headers.remove('Authorization');
      // TODO: Clear token from secure storage
    } catch (e) {
      debugPrint('Failed to sign out: ${e.toString()}');
    }
  }

  // ==================== PASSWORD RESET ====================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dio.post(
        '/auth/password-reset',
        data: {'email': email},
      );
    } on DioException catch (e) {
      debugPrint("Failed to send password reset email: ${e.message}");
      throw _handleError(e);
    }
  }

  // ==================== ERROR HANDLER ====================
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'An error occurred';
        if (statusCode == 400) {
          return message;
        } else if (statusCode == 401) {
          return 'Invalid credentials';
        } else if (statusCode == 409) {
          return 'Email already exists';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return message;
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error. Please check your connection.';
    }
  }
}