import 'package:sports_in/features/login/model/login_response_model.dart';

abstract class ILoginDataSource {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  Future<LoginResponse> loginWithGoogle();

}
