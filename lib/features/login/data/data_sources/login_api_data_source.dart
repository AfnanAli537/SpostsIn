import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/login/data/interface/i_login_data_source.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

@LazySingleton(as: ILoginDataSource)
class LoginApiDataSource implements ILoginDataSource {
  final ApiClient apiClient;

  LoginApiDataSource(this.apiClient);

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<LoginResponse> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: 'YOUR_CLIENT_ID',
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        throw ApiException(
          message: 'Google sign in cancelled',
          key: StringKeys.requestCancelled,
        );
      }

      final auth = await account.authentication;
      if (auth.idToken == null) {
        throw ApiException(
          message: 'Google idToken missing',
          key: StringKeys.unexpectedError,
        );
      }

      final response = await apiClient.post(
        Endpoints.googleSignUp,
        data: {'IdToken': auth.idToken},
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    } on ApiException {
      rethrow;
    }
  }
}