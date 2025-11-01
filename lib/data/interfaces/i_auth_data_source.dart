import 'package:sports_in/data/models/login_response_model.dart';


abstract class IAuthDataSource {
  Future<LoginResponse> login({ required String email,required String password});
  Future<void> logout();
  Future<Map<String,dynamic>?> getCachedUser();
  
}