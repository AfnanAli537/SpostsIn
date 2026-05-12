import 'dart:io';

abstract class UpdateProfileData {
  Map<String, dynamic> toJson();
}

class UpdatePlayerProfile extends UpdateProfileData {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final int? height;
  final int? weight;
  final int? age;
  final String? sportName;
  final String? position;
  final bool? hasClub;
  final File? image;
  final String? imageUrl;

  UpdatePlayerProfile({
    this.userId,
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
    this.age,
    this.sportName,
    this.position,
    this.hasClub,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'UserId': userId,
      if (firstName != null) 'FirstName': firstName,
      if (lastName != null) 'LastName': lastName,
      if (height != null) 'Height': height,
      if (weight != null) 'Weight': weight,
      if (age != null) 'Age': age,
      if (sportName != null) 'SportName': sportName,
      if (position != null) 'Position': position,
      if (hasClub != null) 'HasClub': hasClub,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}

class UpdateCoachProfile extends UpdateProfileData {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? sportName;
  final int? yearsOfExperience;
  final bool? hasClub;
  final File? image;
  final String? imageUrl;

  UpdateCoachProfile({
    this.userId,
    this.firstName,
    this.lastName,
    this.sportName,
    this.yearsOfExperience,
    this.hasClub,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'UserId': userId,
      if (firstName != null) 'FirstName': firstName,
      if (lastName != null) 'LastName': lastName,
      if (sportName != null) 'SportName': sportName,
      if (yearsOfExperience != null) 'YearsOfExperience': yearsOfExperience,
      if (hasClub != null) 'HasClub': hasClub,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}

class UpdateScoutProfile extends UpdateProfileData {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? sportName;
  final int? yearsOfExperience;
  final File? image;
  final String? imageUrl;

  UpdateScoutProfile({
    this.userId,
    this.firstName,
    this.lastName,
    this.sportName,
    this.yearsOfExperience,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'UserId': userId,
      if (firstName != null) 'FirstName': firstName,
      if (lastName != null) 'LastName': lastName,
      // if (gender != null) 'gender': gender,
      // if (location != null) 'location': location,
      if (sportName != null) 'SportName': sportName,
      if (yearsOfExperience != null) 'YearsOfExperience': yearsOfExperience,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}

class UpdateClubProfile extends UpdateProfileData {
  final String? userId;
  final String? clubName;
  // final String? location;
  final String? foundationDate;
  final List<String>? sportTypes;
  final File? image;
  final String? imageUrl;

  UpdateClubProfile({
        this.userId,

    this.clubName,
    // this.location,
    this.foundationDate,
    this.sportTypes,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
            if (userId != null) 'UserId': userId,

      if (clubName != null) 'ClubName': clubName,
      // if (location != null) 'location': location,
      if (foundationDate != null) 'FoundationDate': foundationDate,
      if (sportTypes != null) 'SportTypes': sportTypes,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}

class UpdateInstituteProfile extends UpdateProfileData {
    final String? userId;

  final String? instituteName;
  // final String? location;
  final String? industry;
  final File? image;
  final String? imageUrl;

  UpdateInstituteProfile({
        this.userId,

    this.instituteName,
    // this.location,
    this.industry,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
            if (userId != null) 'UserId': userId,

      if (instituteName != null) 'InstituteName': instituteName,
      // if (location != null) 'location': location,
      if (industry != null) 'Industry': industry,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}

class UpdateOtherProfile extends UpdateProfileData {
    final String? userId;

  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? location;
  final File? image;
  final String? imageUrl;

  UpdateOtherProfile({
        this.userId,

    this.firstName,
    this.lastName,
    this.gender,
    this.location,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
            if (userId != null) 'UserId': userId,
      if (firstName != null) 'FirstName': firstName,
      if (lastName != null) 'LastName': lastName,
      if (gender != null) 'Gender': gender,
      if (location != null) 'Location': location,
      if (imageUrl != null) 'profilePictureUrl': imageUrl,
    };
  }
}