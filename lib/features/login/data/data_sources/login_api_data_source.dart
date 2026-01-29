import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/login/data/interface/i_login_data_source.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';

// @LazySingleton(as: ILoginDataSource)
// class LoginApiDataSource implements ILoginDataSource {
//   final ApiClient apiClient;
//   LoginApiDataSource(this.apiClient);

//   @override
//   Future<LoginResponse> login({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     final response = await apiClient.post(
//       Endpoints.login,
//       data: {'email': email, 'password': password},
//     );

//     if (response.statusCode == 200) {
//       return LoginResponse.fromJson(response.data);
//     }
//     throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
//   }

//   @override
//   Future<LoginResponse> loginWithGoogle() async {
//     final googleSignIn = GoogleSignIn(
//       scopes: ['email', 'profile'],
//       serverClientId: 'YOUR_CLIENT_ID',
//     );

//     final account = await googleSignIn.signIn();
//     if (account == null) throw Exception('Cancelled');

//     final token = (await account.authentication).idToken;
//     if (token == null) throw Exception('Token missing');

//     final response = await apiClient.post(
//       Endpoints.googleSignUp,
//       data: {'IdToken': token},
//     );

//     return LoginResponse.fromJson(response.data);
//   }

// }

@LazySingleton(as: ILoginDataSource)
class LoginApiDataSource implements ILoginDataSource {
  final ApiClient apiClient;

  LoginApiDataSource(this.apiClient);

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    }

    throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
  }

  @override
  Future<LoginResponse> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: 'YOUR_CLIENT_ID',
    );

    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign in cancelled');
    }

    final auth = await account.authentication;
    if (auth.idToken == null) {
      throw Exception('Google idToken missing');
    }

    final response = await apiClient.post(
      Endpoints.googleSignUp,
      data: {'IdToken': auth.idToken},
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    }

    throw ApiErrorHandler.handleStatusCodeKey(response.statusCode);
  }
}
