import 'package:sports_in/core/utils/helper/image_helper.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/data/models/user_model.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/generated/l10n.dart';

Future<Map<String, dynamic>> buildRequestBodyIsolate(
  UserModel user,
  CloudinaryService cloudinaryService,
) async {
  return _buildRequestBody(user, cloudinaryService);
}

Future<Map<String, dynamic>> _buildRequestBody(
  UserModel user,
  CloudinaryService cloudinaryService,
) async {
  S? s;
  try {
    s = S.current;
  } catch (_) {
    s = null;
  }

  final String imageUrl = await cloudinaryService.uploadImage(user.image);

  final genderEnum = user.gender != null
      ? EnumMapper.fromLabel(EnumMapper.genderLabels(s), user.gender!)
      : null;

  final sportEnum = user.sport != null
      ? EnumMapper.fromLabel(EnumMapper.sportLabels(s), user.sport!)
      : null;

  final genderId = genderEnum != null ? EnumMapper.getGenderId(genderEnum) : null;
  final sportId = sportEnum != null ? EnumMapper.getSportId(sportEnum) : null;

  // Always send English API value for location
  final String? locationApiValue = (s != null && user.location != null)
      ? RegisterLists.getLocationApiValue(s, user.location!)
      : user.location;

  // Always send abbreviation for position
  final String? positionApiValue = (s != null && user.position != null)
      ? RegisterLists.getPositionApiValue(s, user.sport, user.position!)
      : user.position;

  Map<String, dynamic> clean(Map<String, dynamic> json) =>
      Map.fromEntries(json.entries.where((e) => e.value != null));

  switch (user.userType) {
    case UserType.player:
      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "height": user.height ?? 0,
        "weight": user.weight ?? 0,
        "sportTypeId": sportId,
        "age": user.age ?? 0,
        "genderId": genderId,
        "hasClub": user.hasClub ?? false,
        "position": positionApiValue,
        "currentClubName": (user.hasClub == true) ? user.currentClubName : null,
        "isAgree": true,
      });

    case UserType.coach:
      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "age": user.age ?? 0,
        "yearsOfExperienceId": user.experienceYears ?? 0,
        "sportTypeId": sportId,
        "genderId": genderId,
        "hasClub": user.hasClub ?? false,
        "currentClubName": (user.hasClub == true) ? user.currentClubName : null,
        "specialist": user.specialist,
        "certificationsIds": user.certificationsIds,
        "isAgree": true,
      });

    case UserType.scout:
      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "age": user.age ?? 0,
        "yearsOfExperienceId": user.experienceYears ?? 0,
        "sportTypeId": sportId,
        "genderId": genderId,
        "isAgree": true,
      });

    case UserType.club:
      final sportIds = (user.sports ?? [])
          .map((label) => EnumMapper.getSportId(
              EnumMapper.fromLabel(EnumMapper.sportLabels(s), label)!))
          .toList();

      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "clubName": user.clubName,
        "foundationDate": user.foundDate,
        "sportTypeIds": sportIds,
        "isAgree": true,
      });

    case UserType.institute:
      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "instituteName": user.instituteName,
        "industry": user.industry,
        "isAgree": true,
      });

    case UserType.others:
      return clean({
        "profilePictureUrl": imageUrl,
        "email": user.email,
        "password": user.password,
        "confirmPassword": user.confirmPassword,
        "location": locationApiValue,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "genderId": genderId,
        "isAgree": true,
      });
  }
}