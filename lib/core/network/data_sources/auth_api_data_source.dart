import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/network/network_checker.dart';
import '../interfaces/i_auth_data_source.dart';

class AuthApiDataSource implements IAuthDataSource {
  final ApiClient apiClient;
  AuthApiDataSource(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final hasConnection = await NetworkChecker.hasInternetConnection();
    if (!hasConnection) throw Exception('No Internet Connection');

    final response = await apiClient.post(Endpoints.login, data: {
      'email': email,
      'password': password,
    });
    return Map<String, dynamic>.from(response.data);
  }


  @override
  Future<void> logout() async {
  }

  @override
  Future<Map<String,dynamic>?> getCachedUser() async {
    return null; 
  }
}
