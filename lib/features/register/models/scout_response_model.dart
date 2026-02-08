import 'package:sports_in/features/register/models/user_model.dart';
class ScoutModel extends UserModel {
  const ScoutModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required int? yearsOfExperience,
    required String sportName,
    required String gender,
    super.image
  }) : super(
          userType: UserType.scout,
          experienceYears: yearsOfExperience,
          sport: sportName,
          gender: gender,
        );

  @override
  Map<String, dynamic> toJson() => {
        // "image": image,
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
