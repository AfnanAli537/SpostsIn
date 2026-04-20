import 'package:injectable/injectable.dart';
import 'package:sports_in/features/register/data/interface/i_register_data_source.dart';
import 'package:sports_in/features/register/models/certification_model.dart';
import 'package:sports_in/features/register/models/user_model.dart';

@lazySingleton
class RegisterRepo {
  final IRegisterDataSource dataSource;
  RegisterRepo(this.dataSource);

  Future<bool> sendRegistrationOtp(String email) =>
      dataSource.sendRegistrationOtp(email);

  Future<bool> verifyRegistrationOtp(String email, String otp) =>
      dataSource.verifyRegistrationOtp(email, otp);

  Future<bool> register(UserModel user) => dataSource.registerUser(user);

  Future<List<CertificationModel>> getCertifications() =>
      dataSource.getCertifications();
}