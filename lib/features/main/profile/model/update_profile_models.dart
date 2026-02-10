import 'dart:io';

abstract class UpdateProfileData {
  Map<String, dynamic> toJson();
}

class UpdatePlayerProfile extends UpdateProfileData {
  final String? firstName;
  final String? lastName;
  final int? height;
  final int? weight;
  final int? age;
  // final String? gender;
  // final String? location;
  final String? sportName;
  final String? position;
  final bool? hasClub;
  final File? image;
  final String? imageUrl;

  UpdatePlayerProfile({
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
    this.age,
    // this.gender,
    // this.location,
    this.sportName,
    this.position,
    this.hasClub,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (age != null) 'age': age,
      // if (gender != null) 'gender': gender,
      // if (location != null) 'location': location,
      if (sportName != null) 'sportName': sportName,
      if (position != null) 'position': position,
      if (hasClub != null) 'hasClub': hasClub,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class UpdateCoachProfile extends UpdateProfileData {
  final String? firstName;
  final String? lastName;
  // final String? gender;
  // final String? location;
  final String? sportName;
  final int? yearsOfExperience;
  final bool? hasClub;
  final File? image;
  final String? imageUrl;

  UpdateCoachProfile({
    this.firstName,
    this.lastName,
    // this.gender,
    // this.location,
    this.sportName,
    this.yearsOfExperience,
    this.hasClub,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      // if (gender != null) 'gender': gender,
      // if (location != null) 'location': location,
      if (sportName != null) 'sportName': sportName,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (hasClub != null) 'hasClub': hasClub,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class UpdateScoutProfile extends UpdateProfileData {
  final String? firstName;
  final String? lastName;
  // final String? gender;
  // final String? location;
  final String? sportName;
  final int? yearsOfExperience;
  final File? image;
  final String? imageUrl;

  UpdateScoutProfile({
    this.firstName,
    this.lastName,
    // this.gender,
    // this.location,
    this.sportName,
    this.yearsOfExperience,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      // if (gender != null) 'gender': gender,
      // if (location != null) 'location': location,
      if (sportName != null) 'sportName': sportName,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class UpdateClubProfile extends UpdateProfileData {
  final String? clubName;
  // final String? location;
  final String? foundationDate;
  final List<String>? sportTypes;
  final File? image;
  final String? imageUrl;

  UpdateClubProfile({
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
      if (clubName != null) 'clubName': clubName,
      // if (location != null) 'location': location,
      if (foundationDate != null) 'foundationDate': foundationDate,
      if (sportTypes != null) 'sportTypes': sportTypes,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class UpdateInstituteProfile extends UpdateProfileData {
  final String? instituteName;
  // final String? location;
  final String? industry;
  final File? image;
  final String? imageUrl;

  UpdateInstituteProfile({
    this.instituteName,
    // this.location,
    this.industry,
    this.image,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (instituteName != null) 'instituteName': instituteName,
      // if (location != null) 'location': location,
      if (industry != null) 'industry': industry,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class UpdateOtherProfile extends UpdateProfileData {
  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? location;
  final File? image;
  final String? imageUrl;

  UpdateOtherProfile({
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
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (gender != null) 'gender': gender,
      if (location != null) 'location': location,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}