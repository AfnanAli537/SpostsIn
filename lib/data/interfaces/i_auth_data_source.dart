import 'package:flutter/material.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/models/user_model.dart';


abstract class IAuthDataSource {
  Future<LoginResponse> login({ required BuildContext context,required String email,required String password});
  Future<void> logout();
  Future<Map<String,dynamic>?> getCachedUser();

  Future<bool> registerUser(UserModel user);
  Future<bool> sendOtp({required String email});
  Future<bool> verifyOtp({required String email,required String otp});
  Future<bool> resetPassword({required String email, required String otp,required String newPassword,required String confirmPassword});
  Future<LoginResponse> loginWithGoogle();
  
}