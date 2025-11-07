import 'package:sports_in/data/models/user_model.dart';

/// 🏃 Player DTO
class PlayerDto extends UserModel {
  const PlayerDto({
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
  }) : super(
          userType: UserType.player,
          sport: sportName
        );

  @override
  Map<String, dynamic> toJson() => {
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
