import 'package:sports_in/features/register/data/models/user_model.dart';

class InstituteModel extends UserModel {
  const InstituteModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.location,
    required super.instituteName,
    required super.industry,
    super.image

  }) : super(
          userType: UserType.institute,
        );

  @override
  Map<String, dynamic> toJson() => {
        "image": image,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "instituteName": instituteName ?? "",
        "industry": industry ?? "",
      };
}
