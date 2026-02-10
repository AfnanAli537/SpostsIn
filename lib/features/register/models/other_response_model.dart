import 'package:sports_in/features/register/models/user_model.dart';

class OtherModel extends UserModel {
  const OtherModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required String gender,
    super.image

  }) : super(
          userType: UserType.others,
          gender: gender,
        );

  @override
  Map<String, dynamic> toJson() => {
        "image": image,

        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
      };
}
