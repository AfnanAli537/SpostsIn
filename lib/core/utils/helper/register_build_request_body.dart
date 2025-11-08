import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/generated/l10n.dart';

Map<String, dynamic> buildRequestBodyIsolate(UserModel user) {
  return _buildRequestBody(user);
}

Map<String, dynamic> _buildRequestBody(UserModel user) {
  final s = S.current;

  final genderEnum = user.gender != null
      ? EnumMapper.fromLabel(EnumMapper.genderLabels(s), user.gender!)
      : null;
  final sportEnum = user.sport != null
      ? EnumMapper.fromLabel(EnumMapper.sportLabels(s), user.sport!)
      : null;

  final genderId = genderEnum != null ? EnumMapper.getGenderId(genderEnum) : null;
  final sportId = sportEnum != null ? EnumMapper.getSportId(sportEnum) : null;

  Map<String, dynamic> clean(Map<String, dynamic> json) =>
      Map.fromEntries(json.entries.where((e) => e.value != null));

  switch (user.userType) {
    case UserType.player:
      return clean({
        "image": user.image,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": user.location,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "height": user.height ?? 0,
        "weight": user.weight ?? 0,
        "sportTypeId": sportId,
        "age": user.age ?? 0,
        "genderId": genderId,
        "hasClub": user.hasClub ?? false,
        "position": user.position,
        "isAgree": true,
      });

    case UserType.coach:
    case UserType.scout:
      return clean({
        "image": user.image,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": user.location,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "yearsOfExperienceId": user.experienceYears ?? 0,
        "sportTypeId": sportId,
        "genderId": genderId,
        "hasClub": user.hasClub ?? false,
        "isAgree": true,
      });

    case UserType.club:
      final sportIds = (user.sports ?? [])
          .map((label) => EnumMapper.getSportId(
              EnumMapper.fromLabel(EnumMapper.sportLabels(s), label)!))
          .toList();

      return clean({
        "image": user.image,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": user.location,
        "clubName": user.clubName,
        "foundationDate": user.foundDate,
        "sportTypeIds": sportIds,
        "isAgree": true,
      });

    case UserType.institute:
      return clean({
        "image": user.image,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": user.location,
        "instituteName": user.instituteName,
        "industry": user.industry,
        "isAgree": true,
      });

    case UserType.others:
      return clean({
        "image": user.image,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": user.location,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "genderId": genderId,
        "isAgree": true,
      });
  }
}
