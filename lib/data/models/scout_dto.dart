import 'package:sports_in/data/models/user_model.dart';
/// 🕵️ Scout DTO
class ScoutDto extends UserModel {
  const ScoutDto({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required int? yearsOfExperience,
    required String sportName,
    required String gender,
  }) : super(
          userType: UserType.scout,
          experienceYears: yearsOfExperience,
          sport: sportName,
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
        "yearsOfExperience":experienceYears ?? 0,
        "sportName":sport,
        "gender": gender,
      };
}
