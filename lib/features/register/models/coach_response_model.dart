import 'package:sports_in/features/register/models/user_model.dart';

class CoachModel extends UserModel {
  const CoachModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required int? yearsOfExperience,
    required String sportName,
    required super.age,
    required String super.gender,
    required super.hasClub,
    super.currentClubName,
    super.specialist,
    super.certificationsIds,
    super.image,
  }) : super(
          userType: UserType.coach,
          experienceYears: yearsOfExperience,
          sport: sportName,
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
        "yearsOfExperience": experienceYears?? 0,
        "sportName": sport ,
        "age": age ?? 0,
        "gender":gender,
        "club": hasClub ?? false,
        "currentClubName": currentClubName,
        "specialist": specialist,
        "certificationsIds": certificationsIds,
      };
}

