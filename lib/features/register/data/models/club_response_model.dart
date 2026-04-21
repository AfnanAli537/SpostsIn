import 'package:sports_in/features/register/data/models/user_model.dart';

class ClubModel extends UserModel {
  ClubModel({
    required super.email,
    required super.password,
    required super.confirmPassword,
    required String super.location,
    required String super.clubName,
    required String foundationDate,
    required List<String?> sportTypes,
    super.image

  }) : super(
          userType: UserType.club,
          foundDate: foundationDate,
          sports: sportTypes.map((e) => e.toString()).toList(),
        );

  @override
  Map<String, dynamic> toJson() => {
        "image": image,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "location": location,
        "clubName": clubName ?? "",
        "foundationDate": foundDate ?? DateTime.now().toIso8601String(),
        "sportTypeIds": sports?.map((e) => int.tryParse(e) ?? 0).toList() ?? [],
      };
}
