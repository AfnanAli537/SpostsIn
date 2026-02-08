import 'dart:io';
import 'package:sports_in/core/utils/helper/image_helper.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/generated/l10n.dart';

class UpdateProfileBodyBuilder {
  static Future<Map<String, dynamic>> buildUpdateBody({
    required ProfileModel currentProfile,
    File? newImage,
    String? firstName,
    String? lastName,
    String? bio,
    List<String>? sports,
    int? height,
    int? weight,
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

    // Upload new image if provided
    String? profilePictureUrl = currentProfile.profileImage;
    if (newImage != null) {
      profilePictureUrl = await CloudinaryService.uploadImage(newImage);
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

    // Convert sports to IDs if provided
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

    // Build the complete body with all fields
    final body = <String, dynamic>{
      "userId": currentProfile.id,
      "fullName": fullName,
      "userType": _getUserTypeString(currentProfile.userType),
      "profilePictureUrl": profilePictureUrl,
      "bio": bio ?? currentProfile.description,
      "sports": sportIds ?? [],
      "followersCount": currentProfile.stats.followers,
      "followingCount": currentProfile.stats.following,
      "connectionsCount": currentProfile.stats.connections,
      "analyzedPeopleCount": currentProfile.stats.analyzedPeople,
    };

    // Add user-type specific fields based on current profile type
    switch (currentProfile.userType) {
      case UserType.player:
        final playerData = currentProfile.playerData!;
        body.addAll({
          "height": height ?? playerData.height,
          "weight": weight ?? playerData.weight,
          "position": position ?? playerData.position,
          "age": age ?? playerData.age,
          "gender": playerData.gender, // You might need to get this from current profile
          "yearsOfExperience": null,
          "specialization": specialization ?? playerData.specializedSport,
          "foundationDate": null,
          "industry": null,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.coach:
        final coachData = currentProfile.coachData!;
        body.addAll({
          "height": null,
          "weight": null,
          "position": null,
          "age": null,
          "gender": coachData.gender,
          "yearsOfExperience": yearsOfExperience ?? coachData.yearsOfExperience,
          "specialization": specialization ?? coachData.specializedSport,
          "foundationDate": null,
          "industry": null,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.scout:
        final scoutData = currentProfile.scoutData!;
        body.addAll({
          "height": null,
          "weight": null,
          "position": null,
          "age": null,
          "gender": scoutData.gender,
          "yearsOfExperience": yearsOfExperience ?? scoutData.yearsOfExperience,
          "specialization": specialization ?? scoutData.specializedSport,
          "foundationDate": null,
          "industry": null,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.club:
        final clubData = currentProfile.clubData!;
        body.addAll({
          "height": null,
          "weight": null,
          "position": null,
          "age": null,
          "gender": null,
          "yearsOfExperience": null,
          "specialization": null,
          "foundationDate": foundationDate ?? clubData.foundedYear,
          "industry": null,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.institute:
        final instituteData = currentProfile.instituteData!;
        body.addAll({
          "height": null,
          "weight": null,
          "position": null,
          "age": null,
          "gender": null,
          "yearsOfExperience": null,
          "specialization": null,
          "foundationDate": null,
          "industry": industry ?? instituteData.industry,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
        });
        break;

      case UserType.other:
        final otherData = currentProfile.otherData!;
        body.addAll({
          "height": null,
          "weight": null,
          "position": null,
          "age": null,
          "gender": otherData.gender ?? genderId,
          "yearsOfExperience": null,
          "specialization": null,
          "foundationDate": null,
          "industry": null,
          "isOwner": true,
          "isFollowedByMe": currentProfile.isFollowing,
          "connectionStatus": currentProfile.isConnected ? "Connected" : "NotConnected",
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