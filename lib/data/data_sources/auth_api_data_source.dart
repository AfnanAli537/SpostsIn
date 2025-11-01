import 'package:dio/dio.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import '../interfaces/i_auth_data_source.dart';

class AuthApiDataSource implements IAuthDataSource {
  final ApiClient apiClient;
  AuthApiDataSource(this.apiClient);

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final hasConnection = await NetworkChecker.hasInternetConnection();
    if (!hasConnection) throw Exception('No Internet Connection');

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
        
      } else {
        throw ApiErrorHandler.handleStatusCode(response.statusCode);
      }
    } on DioException catch (dioError) {
      throw ApiErrorHandler.handleDioError(dioError);
    } catch (e) {
      throw ApiErrorHandler.handleUnknownError(e);
    }
  
  }


  @override
  Future<void> logout() async {
  }

  @override
  Future<Map<String,dynamic>?> getCachedUser() async {
    return null; 
  }
}
