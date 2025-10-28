import 'package:sports_in/core/network/interfaces/i_auth_data_source.dart';

class AuthService {
  final IAuthDataSource dataSource;
  AuthService(this.dataSource);

  Future<Map<String, dynamic>> login(String email, String password) {
    return dataSource.login(email, password);
  }
  Future<void> logout() => dataSource.logout();
  Future<Map<String,dynamic>?> getCachedUser() => dataSource.getCachedUser();
}
