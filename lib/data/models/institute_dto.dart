import 'package:sports_in/data/models/user_model.dart';

/// 🏫 Institute DTO
class InstituteDto extends UserModel {
  const InstituteDto({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.location,
    required super.instituteName,
    required super.industry,
  }) : super(
          userType: UserType.institute,
        );

  @override
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "instituteName": instituteName ?? "",
        "industry": industry ?? "",
      };
}
