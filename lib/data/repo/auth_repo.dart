
import 'package:injectable/injectable.dart';
import 'package:sports_in/data/interfaces/i_auth_data_source.dart';

@lazySingleton
class AuthRepo {
  final IAuthDataSource dataSource;
  AuthRepo(this.dataSource);

  Future<void> logout() => dataSource.logout();
  Future<Map<String, dynamic>?> getCachedUser() => dataSource.getCachedUser();
}
