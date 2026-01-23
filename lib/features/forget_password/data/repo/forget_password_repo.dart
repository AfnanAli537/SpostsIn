import 'package:injectable/injectable.dart';
import 'package:sports_in/features/forget_password/data/interface/i_forget_password_data_source.dart';

@lazySingleton
class ForgetPasswordRepo {
  final IForgetPasswordDataSource dataSource;
  ForgetPasswordRepo(this.dataSource);

  Future<bool> sendOtp(String email) =>
      dataSource.sendOtp(email);

  Future<bool> verifyOtp(String email, String otp) =>
      dataSource.verifyOtp(email, otp);

  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) =>
      dataSource.resetPassword(
        email,
        otp,
        newPassword,
        confirmPassword,
      );
}
