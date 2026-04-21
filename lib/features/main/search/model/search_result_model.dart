class SearchResultModel {
  final String id;
  final String name;
  final String role;
  final String profileImage;
  final UserType userType;
  final String? location;
  final int? age;

  SearchResultModel({
    required this.id,
    required this.name,
    required this.role,
    required this.profileImage,
    required this.userType,
    this.location,
    this.age,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['userId']?.toString() ?? '',
      name: json['fullName'] ?? '',
      role: json['userType'] ?? '',
      profileImage: json['profilePictureUrl'] ?? '',
      userType: UserType.fromApi(json['userType']),
      location: json['location'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': id,
    'name': name,
    'role': role,
    'profileImage': profileImage,
    'userType': userType.apiValue,
    'location': location,
    'age': age,
  };
}

enum UserType {
  player,
  coach,
  scout,
  club,
  institute,
  other;

String get apiValue {
  switch (this) {
    case UserType.player:     return 'Player';
    case UserType.coach:      return 'Coach';
    case UserType.scout:      return 'Scout';
    case UserType.club:       return 'Club';
    case UserType.institute:  return 'Institute';
    case UserType.other:      return 'Other';
  }
}

  /// Display label shown in the dropdown
  String get label {
    switch (this) {
      case UserType.player:
        return 'Player';
      case UserType.coach:
        return 'Coach';
      case UserType.scout:
        return 'Scout';
      case UserType.club:
        return 'Club';
      case UserType.institute:
        return 'Institute';
      case UserType.other:
        return 'Other';
    }
  }

static UserType fromApi(String? value) {
  return UserType.values.firstWhere(
    (e) => e.apiValue.toLowerCase() == value?.toLowerCase(),
    orElse: () => UserType.player,
  );
}
}

class SearchFilters {
  final int? minAge;
  final int? maxAge;
  final String? location;
  final String? position;
  final int? sportTypeId; // replaces typeOfPlay string
  final UserType? userType;
  final int pageNumber;
  final int pageSize;

  SearchFilters({
    this.minAge,
    this.maxAge,
    this.location,
    this.position,
    this.sportTypeId,
    this.userType,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() => {
    'minAge': minAge,
    'maxAge': maxAge,
    'location': location,
    'position': position,
    'sportTypeId': sportTypeId,
    'userType': userType?.apiValue,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
  };

  SearchFilters copyWith({
    int? minAge,
    int? maxAge,
    String? location,
    String? position,
    int? sportTypeId,
    UserType? userType,
    int? pageNumber,
    int? pageSize,
  }) {
    return SearchFilters(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      location: location ?? this.location,
      position: position ?? this.position,
      sportTypeId: sportTypeId ?? this.sportTypeId,
      userType: userType ?? this.userType,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
