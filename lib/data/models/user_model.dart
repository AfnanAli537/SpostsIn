import 'dart:io';
import 'package:equatable/equatable.dart';

enum UserType {
  player,
  coach,
  scout,
  club,
  institute,
  others,
}

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
  final String? height;
  final String? weight;
  final bool? hasClub;

  // Coach-specific
  final String? experienceYears;
  final String? specialization;

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
    this.hasClub,
    this.experienceYears,
    this.specialization,
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
    String? birthDate,
    String? height,
    String? weight,
    String? nationality,
    bool? hasClub,
    String? experienceYears,
    String? specialization,
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
      hasClub: hasClub ?? this.hasClub,
      experienceYears: experienceYears ?? this.experienceYears,
      specialization: specialization ?? this.specialization,
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
      // Add image upload logic separately
      if (sport != null) 'sport': sport,
      if (position != null) 'position': position,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (hasClub != null) 'hasClub': hasClub,
      if (experienceYears != null) 'experienceYears': experienceYears,
      if (specialization != null) 'specialization': specialization,
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
        firstName,
        lastName,
        gender,
        location,
        image,
        sport,
        position,
        height,
        weight,
        hasClub,
        experienceYears,
        specialization,
        agencyName,
        clubName,
        foundDate,
        sports,
        instituteName,
        industry,
      ];
}