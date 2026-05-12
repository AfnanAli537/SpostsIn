import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/models/user_model.dart';

abstract class IRegisterDataSource {
  Future<bool> sendRegistrationOtp(String email);
  Future<bool> verifyRegistrationOtp(String email, String otp);
  Future<bool> registerUser(UserModel user);
  Future<List<CertificationModel>> getCertifications();
}