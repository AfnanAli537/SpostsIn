import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/features/register/data/interface/i_register_data_source.dart';
import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/models/user_model.dart';

@LazySingleton(as: IRegisterDataSource)
class RegisterApiDataSource implements IRegisterDataSource {
  final ApiClient apiClient;

  RegisterApiDataSource(this.apiClient);

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  @override
  Future<bool> sendRegistrationOtp(String email) async {
    try {
      debugPrint('Sending OTP for email: $email');
      final response = await apiClient.post(
        Endpoints.sendVerifyRegisterOtp,
        params: {'email': email},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('OTP sent successfully for email: $email');
        return true;
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<bool> verifyRegistrationOtp(String email, String otp) async {
    try {
      final response = await apiClient.post(
        Endpoints.verifyRegisterOtp,
        params: {'email': email, 'code': otp},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('OTP verified successfully for email: $email');
        return true;
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<bool> registerUser(UserModel user) async {
    try {
      final endpoint = getEndpointForUserType(user.userType);
      final body = await buildRequestBodyIsolate(user);
      final response = await apiClient.post(endpoint, data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('User registered successfully');
        return response.data['isSuccess'] == true;
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<CertificationModel>> getCertifications() async {
    try {
      final response = await apiClient.get(Endpoints.certifications);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}