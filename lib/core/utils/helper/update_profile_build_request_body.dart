import 'dart:io';
// import 'package:dio/dio.dart';
import 'package:sports_in/core/utils/helper/image_helper.dart';
// import 'package:sports_in/core/utils/helper/image_helper.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/generated/l10n.dart';

class UpdateProfileBodyBuilder {
  static Future<Map<String, dynamic>> buildUpdateBody({
    required ProfileModel currentProfile,
    File? newImage,
    String? oldImage,
    String? firstName,
    String? lastName,
    String? bio,
    List<String>? sports,
    double? height,
    double? weight,
    String? position,
    int? age,
    String? gender,
    int? yearsOfExperience,
    String? specialization,
    String? foundationDate,
    String? industry,
    String? clubName,
    String? instituteName,
    String? location,
    bool? hasClub,
  }) async {
    S? s;
    try {
      s = S.current;
    } catch (_) {
      s = null;
    }


    // Build full name
    String fullName = currentProfile.name;
    if (firstName != null || lastName != null) {
      final fName = firstName ?? currentProfile.name.split(' ').first;
      final lName = lastName ?? currentProfile.name.split(' ').last;
      fullName = '$fName $lName';
    } else if (clubName != null) {
      fullName = clubName;
    } else if (instituteName != null) {
      fullName = instituteName;
    }

    // Convert gender to ID if provided
    int? genderId;
    if (gender != null) {
      final genderEnum = EnumMapper.fromLabel(
        EnumMapper.genderLabels(s),
        gender,
      );
      genderId = genderEnum != null ? EnumMapper.getGenderId(genderEnum) : null;
    }

    List<String>? sportIds;
    if (sports != null && sports.isNotEmpty) {
      sportIds = sports
          .map((label) {
            final sportEnum = EnumMapper.fromLabel(
              EnumMapper.sportLabels(s),
              label,
            );
            return sportEnum != null
                ? EnumMapper.getSportId(sportEnum).toString()
                : null;
          })
          .whereType<String>()
          .toList();
    }

    final body = <String, dynamic>{
      "UserId": currentProfile.id,
      "FullName": fullName,
      "UserType": _getUserTypeString(currentProfile.userType),
      "ProfilePictureUrl": newImage != null
          ? await CloudinaryService.uploadImage(newImage)
          : oldImage,
      "Bio": bio ?? currentProfile.description,
      "Sports": sportIds??sports ?? [],
      "FollowersCount": currentProfile.stats.followers,
      "FollowingCount": currentProfile.stats.following,
      "ConnectionsCount": currentProfile.stats.connections,
      "AnalyzedPeopleCount": currentProfile.stats.analyzedPeople,
    };

    switch (currentProfile.userType) {
      case UserType.player:
        final playerData = currentProfile.playerData!;
        body.addAll({
          "Height": height ?? playerData.height,
          "Weight": weight ?? playerData.weight,
          "Position": position ?? playerData.position,
          "Age": age ?? playerData.age,
          if(playerData.gender!=0 && playerData.gender != null)"Gender": playerData.gender, 
          "YearsOfExperience": null,
          "Specialization": specialization ?? playerData.specializedSport,
          "FoundationDate": null,
          "Industry": null,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.coach:
        final coachData = currentProfile.coachData!;
        body.addAll({
          "Height": null,
          "Weight": null,
          "Position": null,
          "Age": null,
          if(coachData.gender!=0 && coachData.gender != null)"Gender": coachData.gender,
          "YearsOfExperience": yearsOfExperience ?? coachData.yearsOfExperience,
          "Specialization": specialization ?? coachData.specializedSport,
          "FoundationDate": null,
          "Industry": null,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.scout:
        final scoutData = currentProfile.scoutData!;
        body.addAll({
          "Height": null,
          "Weight": null,
          "Position": null,
          "Age": null,
          if(scoutData.gender!=0 && scoutData.gender != null)"Gender": scoutData.gender,
          "YearsOfExperience": yearsOfExperience ?? scoutData.yearsOfExperience,
          "Specialization": specialization ?? scoutData.specializedSport,
          "FoundationDate": null,
          "Industry": null,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.club:
        final clubData = currentProfile.clubData!;
        body.addAll({
          "Height": null,
          "Weight": null,
          "Position": null,
          "Age": null,
          "YearsOfExperience": null,
          "Specialization": null,
          "FoundationDate": foundationDate ?? clubData.foundedYear,
          "Industry": null,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.institute:
        final instituteData = currentProfile.instituteData!;
        body.addAll({
          "Height": null,
          "Weight": null,
          "Position": null,
          "Age": null,
          "YearsOfExperience": null,
          "Specialization": null,
          "FoundationDate": null,
          "Industry": industry ?? instituteData.industry,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.other:
        final otherData = currentProfile.otherData!;
        body.addAll({
          "Height": null,
          "Weight": null,
          "Position": null,
          "Age": null,
          if(otherData.gender!=0 && otherData.gender != null)"Gender": genderId ?? otherData.gender,
          "YearsOfExperience": null,
          "Specialization": null,
          "FoundationDate": null,
          "Industry": null,
          "IsOwner": true,
          "IsFollowedByMe": currentProfile.isFollowing,
          "ConnectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;
    }

    return body;
  }

  static String _getUserTypeString(UserType type) {
    switch (type) {
      case UserType.player:
        return "Player";
      case UserType.coach:
        return "Coach";
      case UserType.scout:
        return "Scout";
      case UserType.club:
        return "Club";
      case UserType.institute:
        return "Institute";
      case UserType.other:
        return "Other";
    }
  }
}