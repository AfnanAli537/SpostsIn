import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/forget_password/data/interface/i_forget_password_data_source.dart';

@LazySingleton(as: IForgetPasswordDataSource)
class ForgetPasswordApiDataSource
    implements IForgetPasswordDataSource {
  final ApiClient apiClient;
  ForgetPasswordApiDataSource(this.apiClient);

  @override
  Future<bool> sendOtp(String email) async {
    final response = await apiClient.post(
      Endpoints.sendOtp,
      data: {'email': email},
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    final response = await apiClient.post(
      Endpoints.verifyOtp,
      data: {'email': email, 'code': otp},
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    final response = await apiClient.post(
      Endpoints.resetPassword,
      data: {
        'email': email,
        'code': otp,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return response.statusCode == 200;
  }
}
