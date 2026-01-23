import 'package:injectable/injectable.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/utils/helper/auth_api_helper.dart';
import 'package:sports_in/core/utils/helper/register_build_request_body.dart';
import 'package:sports_in/features/register/data/interface/i_register_data_source.dart';
import 'package:sports_in/features/register/models/user_model.dart';

@LazySingleton(as: IRegisterDataSource)
class RegisterApiDataSource implements IRegisterDataSource {
  final ApiClient apiClient;
  RegisterApiDataSource(this.apiClient);

  @override
  Future<bool> registerUser(UserModel user) async {
    final endpoint = getEndpointForUserType(user.userType);
    final body = await buildRequestBodyIsolate(user);

    final response = await apiClient.post(endpoint, data: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['isSuccess'] == true;
    }
    throw ApiException(
      message: 'Registration failed',
      key: StringKeys.validationError,
    );
  }
}
