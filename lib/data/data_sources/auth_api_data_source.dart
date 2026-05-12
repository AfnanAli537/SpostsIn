
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/data/interfaces/i_auth_data_source.dart';

@LazySingleton(as: IAuthDataSource)
class AuthApiDataSource implements IAuthDataSource {
  final ApiClient apiClient;
  AuthApiDataSource(this.apiClient);

  @override
  Future<void> logout() async {}

  @override
  Future<Map<String, dynamic>?> getCachedUser() async {
    return null;
  }
}
