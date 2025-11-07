import 'package:sports_in/data/models/user_model.dart';

/// 👤 Other DTO
class OtherDto extends UserModel {
  const OtherDto({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required String gender,
  }) : super(
          userType: UserType.others,
          gender: gender,
        );

  @override
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
      };
}
