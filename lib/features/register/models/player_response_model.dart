import 'package:sports_in/features/register/models/user_model.dart';

class PlayerModel extends UserModel {
  const PlayerModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.firstName,
    required String super.lastName,
    required super.height,
    required super.weight,
    required String sportName,
    required super.age,
    required String super.gender,
    required super.hasClub,
    super.position,
    super.image
  }) : super(
          userType: UserType.player,
          sport: sportName
        );

  @override
  Map<String, dynamic> toJson() => {
        // "pfp": image,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "firstName": firstName,
        "lastName": lastName,
        "height":height ?? 0,
        "weight": weight ?? 0,
        "sportName":sport,
        "age": age ?? 0,
        "gender": gender??"",
        "hasClub": clubName ?? false,
        "position": position ?? "",
      };
}
