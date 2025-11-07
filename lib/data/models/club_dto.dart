import 'package:sports_in/data/models/user_model.dart';

/// 🏟️ Club DTO
class ClubDto extends UserModel {
  ClubDto({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.clubName,
    required String foundationDate,
    required List<String?> sportTypes,
  }) : super(
          userType: UserType.club,
          foundDate: foundationDate,
          sports: sportTypes.map((e) => e.toString()).toList(),
        );

  @override
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "clubName": clubName ?? "",
        "foundationDate": foundDate ?? DateTime.now().toIso8601String(),
        "sportTypeIds": sports?.map((e) => int.tryParse(e) ?? 0).toList() ?? [],
      };
}
