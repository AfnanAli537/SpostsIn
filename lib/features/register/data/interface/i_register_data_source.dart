import 'package:sports_in/features/register/models/user_model.dart';
abstract class IRegisterDataSource {
  Future<bool> registerUser(UserModel user);
}
