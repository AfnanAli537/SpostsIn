import 'dart:io';
import 'package:equatable/equatable.dart';

enum UserType { player, coach, scout, club, institute, others }

class UserModel extends Equatable {
  final UserType userType;
  final String email;
  final String password;
  final String confirmPassword;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? location;
  final File? image;

  // Player-specific
  final String? sport;
  final String? position;
  final double? height;
  final double? weight;
  final int? age;
  final bool? hasClub;
  final String? currentClubName;

  // Coach-specific
  final int? experienceYears;
  final String? specialization;
  final String? specialist;
  final List<int>? certificationsIds;

  // Scout-specific
  final String? agencyName;

  // Club-specific
  final String? clubName;
  final String? foundDate;
  final List<String>? sports;

  // Institute-specific
  final String? instituteName;
  final String? industry;

  const UserModel({
    required this.userType,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.firstName,
    this.lastName,
    this.gender,
    this.location,
    this.image,
    this.sport,
    this.position,
    this.height,
    this.weight,
    this.age,
    this.hasClub,
    this.currentClubName,
    this.experienceYears,
    this.specialization,
    this.specialist,
    this.certificationsIds,
    this.agencyName,
    this.clubName,
    this.foundDate,
    this.sports,
    this.instituteName,
    this.industry,
  });

  UserModel copyWith({
    UserType? userType,
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? gender,
    String? location,
    File? image,
    String? sport,
    String? position,
    double? height,
    double? weight,
    int? age,
    bool? hasClub,
    String? currentClubName,
    int? experienceYears,
    String? specialization,
    String? specialist,
    List<int>? certificationsIds,
    String? agencyName,
    String? clubName,
    String? foundDate,
    List<String>? sports,
    String? instituteName,
    String? industry,
  }) {
    return UserModel(
      userType: userType ?? this.userType,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      image: image ?? this.image,
      sport: sport ?? this.sport,
      position: position ?? this.position,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      hasClub: hasClub ?? this.hasClub,
      currentClubName: currentClubName ?? this.currentClubName,
      experienceYears: experienceYears ?? this.experienceYears,
      specialization: specialization ?? this.specialization,
      specialist: specialist ?? this.specialist,
      certificationsIds: certificationsIds ?? this.certificationsIds,
      agencyName: agencyName ?? this.agencyName,
      clubName: clubName ?? this.clubName,
      foundDate: foundDate ?? this.foundDate,
      sports: sports ?? this.sports,
      instituteName: instituteName ?? this.instituteName,
      industry: industry ?? this.industry,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType.name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'location': location,
      if (image != null) 'image': image,
      if (sport != null) 'sport': sport,
      if (position != null) 'position': position,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (age != null) 'age': age,
      if (hasClub != null) 'hasClub': hasClub,
      if (currentClubName != null) 'currentClubName': currentClubName,
      if (experienceYears != null) 'experienceYears': experienceYears,
      if (specialization != null) 'specialization': specialization,
      if (specialist != null) 'specialist': specialist,
      if (certificationsIds != null) 'certificationsIds': certificationsIds,
      if (agencyName != null) 'agencyName': agencyName,
      if (clubName != null) 'clubName': clubName,
      if (foundDate != null) 'foundDate': foundDate,
      if (sports != null) 'sports': sports,
      if (instituteName != null) 'instituteName': instituteName,
      if (industry != null) 'industry': industry,
    };
  }

  @override
  List<Object?> get props => [
    userType,
    email,
    password,
    confirmPassword,
    firstName,
    lastName,
    gender,
    location,
    image,
    sport,
    position,
    height,
    weight,
    age,
    hasClub,
    currentClubName,
    experienceYears,
    specialization,
    specialist,
    certificationsIds,
    agencyName,
    clubName,
    foundDate,
    sports,
    instituteName,
    industry,
  ];
}
