abstract class IForgetPasswordDataSource {
  Future<bool> sendOtp(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  );
}

