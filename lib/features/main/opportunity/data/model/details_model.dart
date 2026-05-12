class MatchCriteria {
  final String? targetUserType;
  final dynamic targetGender; // Can be int from API or String from UI
  final int? minAge;
  final int? maxAge;
  final String? targetLocation;
  final String? targetPosition;
  final double? minHeight;
  final double? maxHeight;
  final double? minWeight;
  final double? maxWeight;
  final String? preferredClubExperience;
  final String? targetSpecialization;
  final int? minExperienceYears;
  final String? requiredCertifications; // comma-separated IDs: "1,2,3"
  final int? gender;

  MatchCriteria({
    this.targetUserType,
    this.targetGender,
    this.minAge,
    this.maxAge,
    this.targetLocation,
    this.targetPosition,
    this.minHeight,
    this.maxHeight,
    this.minWeight,
    this.maxWeight,
    this.preferredClubExperience,
    this.targetSpecialization,
    this.minExperienceYears,
    this.requiredCertifications,
    this.gender,
  });

  /// Convert gender integer from API to display string
  String? get genderDisplayValue {
    if (targetGender == null) return null;
    if (targetGender is String) return targetGender; // Already a string
    if (targetGender is int) {
      // Map: 1=Male, 2=Female, etc.
      return targetGender == 1 ? 'Male' : targetGender == 2 ? 'Female' : null;
    }
    return null;
  }

  factory MatchCriteria.fromJson(Map<String, dynamic> json) {
    return MatchCriteria(
      targetUserType: json['targetUserType'],
      targetGender: json['targetGender'], // Keep as-is (can be int or String)
      minAge: json['minAge'],
      maxAge: json['maxAge'],
      targetLocation: json['targetLocation'],
      targetPosition: json['targetPosition'],
      minHeight: json['minHeight'] != null
          ? (json['minHeight'] as num).toDouble()
          : null,
      maxHeight: json['maxHeight'] != null
          ? (json['maxHeight'] as num).toDouble()
          : null,
      minWeight: json['minWeight'] != null
          ? (json['minWeight'] as num).toDouble()
          : null,
      maxWeight: json['maxWeight'] != null
          ? (json['maxWeight'] as num).toDouble()
          : null,
      preferredClubExperience: json['preferredClubExperience'],
      targetSpecialization: json['targetSpecialization'],
      minExperienceYears: json['minExperienceYears'],
      requiredCertifications: json['requiredCertifications'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetUserType': targetUserType,
      'targetGender': targetGender,
      'minAge': minAge,
      'maxAge': maxAge,
      'targetLocation': targetLocation,
      'targetPosition': targetPosition,
      'minHeight': minHeight,
      'maxHeight': maxHeight,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'preferredClubExperience': preferredClubExperience,
      'targetSpecialization': targetSpecialization,
      'minExperienceYears': minExperienceYears,
      'requiredCertifications': requiredCertifications,
      'gender': gender,
    };
  }

  /// Parse comma-separated certification IDs to list of integers
  List<int> getCertificationIds() {
    if (requiredCertifications == null || requiredCertifications!.isEmpty) {
      return [];
    }
    return requiredCertifications!
        .split(',')
        .map((id) => int.tryParse(id.trim()) ?? 0)
        .where((id) => id != 0)
        .toList();
  }

  bool get hasAnyCriteria =>
      targetUserType != null ||
      targetGender != null ||
      minAge != null ||
      maxAge != null ||
      targetLocation != null ||
      targetPosition != null ||
      minHeight != null ||
      maxHeight != null ||
      minWeight != null ||
      maxWeight != null ||
      preferredClubExperience != null ||
      targetSpecialization != null ||
      minExperienceYears != null ||
      requiredCertifications != null;
}

class DetailsModel {
  final String title;
  final String description;
  final String? additionalNotes;
  final DateTime endDate;
  final int sportTypeId;
  final String? mediaFile;
  final String? uploadedMediaUrl;
  final bool isAlreadyApplied;
  final MatchCriteria? matchCriteria;

  DetailsModel({
    required this.title,
    required this.description,
    this.additionalNotes,
    required this.endDate,
    required this.sportTypeId,
    this.mediaFile,
    this.uploadedMediaUrl,
    required this.isAlreadyApplied,
    this.matchCriteria,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      additionalNotes: json['additionalNotes'],
      endDate: DateTime.parse(json['endDate']),
      sportTypeId: json['sportTypeId'] ?? 0,
      mediaFile: json['mediaFile'],
      uploadedMediaUrl: json['uploadedMediaUrl'],
      isAlreadyApplied: json['isAlreadyApplied'] ?? false,
      matchCriteria: json['matchCriteria'] != null
          ? MatchCriteria.fromJson(json['matchCriteria'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'additionalNotes': additionalNotes,
      'endDate': endDate.toIso8601String(),
      'sportTypeId': sportTypeId,
      'mediaFile': mediaFile,
      'uploadedMediaUrl': uploadedMediaUrl,
      'isAlreadyApplied': isAlreadyApplied,
      'matchCriteria': matchCriteria?.toJson(),
    };
  }
}