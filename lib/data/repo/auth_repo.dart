import 'package:flutter/material.dart';
import 'package:sports_in/data/interfaces/i_auth_data_source.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';

class AuthRepo {
  final IAuthDataSource dataSource;
  AuthRepo(this.dataSource);

  Future<LoginResponse> login({
    required BuildContext context,
    required String email,
    required String password,
  }) => dataSource.login(context: context, email: email, password: password);

  Future<void> logout() => dataSource.logout();
  Future<Map<String, dynamic>?> getCachedUser() => dataSource.getCachedUser();

  Future<bool> registerUser(UserModel user) => dataSource.registerUser(user);
  Future<bool> sendOtp(String email) => dataSource.sendOtp(email: email);
  Future<bool> verifyOtp(String email, String otp) =>
      dataSource.verifyOtp(email: email, otp: otp);
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) => dataSource.resetPassword(
    email: email,
    otp: otp,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );
  Future<LoginResponse> loginWithGoogle() =>
      dataSource.loginWithGoogle();
}
