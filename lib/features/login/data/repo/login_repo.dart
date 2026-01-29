// import 'package:injectable/injectable.dart';
// import 'package:sports_in/features/login/data/interface/i_login_data_source.dart';
// import 'package:sports_in/features/login/model/login_response_model.dart';

// @lazySingleton
// class LoginRepo {
//   final ILoginDataSource dataSource;
  
//   LoginRepo(this.dataSource);

//   Future<LoginResponse> login(
//      { required String email, required String password}) =>
//       dataSource.login(
//         email: email,
//         password: password,
//       );

//   Future<LoginResponse> loginWithGoogle() =>
//       dataSource.loginWithGoogle();
// }

import 'package:injectable/injectable.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/login/data/interface/i_login_data_source.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

@lazySingleton
class LoginRepo {
  final ILoginDataSource dataSource;
  final SharedPref sharedPref;

  LoginRepo(this.dataSource, this.sharedPref);

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await dataSource.login(
      email: email,
      password: password,
    );

    await _saveAuthData(response);
    return response;
  }

  Future<LoginResponse> loginWithGoogle() async {
    final response = await dataSource.loginWithGoogle();

    await _saveAuthData(response);
    return response;
  }

  Future<void> _saveAuthData(LoginResponse response) async {
    await sharedPref.saveToken(response.token);
    await sharedPref.saveExpiryDate(response.expiresAt!);
   
  }
}
