import 'package:flutter/material.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

abstract class ILoginDataSource {
  Future<LoginResponse> login({
    required BuildContext context,
    required String email,
    required String password,
  });

  Future<LoginResponse> loginWithGoogle();
}
