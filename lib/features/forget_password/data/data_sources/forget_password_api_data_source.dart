import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/forget_password/data/interface/i_forget_password_data_source.dart';

@LazySingleton(as: IForgetPasswordDataSource)
class ForgetPasswordApiDataSource implements IForgetPasswordDataSource {
  final ApiClient apiClient;

  ForgetPasswordApiDataSource(this.apiClient);

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  @override
  Future<bool> sendOtp(String email) async {
    try {
      final response = await apiClient.post(
        Endpoints.sendOtp,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await apiClient.post(
        Endpoints.verifyOtp,
        data: {'email': email, 'code': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final response = await apiClient.post(
        Endpoints.resetPassword,
        data: {
          'email': email,
          'code': otp,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}