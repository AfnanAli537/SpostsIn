import 'package:sports_in/features/register/models/user_model.dart';

abstract class IRegisterDataSource {
  Future<bool> sendRegistrationOtp(String email);
  Future<bool> verifyRegistrationOtp(String email, String otp);
  Future<bool> registerUser(UserModel user);
}