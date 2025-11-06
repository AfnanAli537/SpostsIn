import 'package:sports_in/data/interfaces/i_auth_data_source.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';


class AuthRepo {
  final IAuthDataSource dataSource;
  AuthRepo(this.dataSource);

  Future<LoginResponse> login({ required String email,required String password}) {
    return dataSource.login(email:email, password: password);
  }
  Future<void> logout() => dataSource.logout();
  Future<Map<String,dynamic>?> getCachedUser() => dataSource.getCachedUser();

   Future<bool> registerUser(UserModel user) => dataSource.registerUser(user);
}
