import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/features/login/data/interface/i_login_data_source.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

@lazySingleton
class LoginRepo {
  final ILoginDataSource dataSource;
  LoginRepo(this.dataSource);

  Future<LoginResponse> login(
     {required BuildContext context, required String email, required String password}) =>
      dataSource.login(
        context: context,
        email: email,
        password: password,
      );

  Future<LoginResponse> loginWithGoogle() =>
      dataSource.loginWithGoogle();
}
