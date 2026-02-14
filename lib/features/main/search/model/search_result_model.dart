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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'] ?? '',
      userType: _parseUserType(json['userType'] ?? json['user_type']),
      location: json['location'],
      age: json['age'],
    );
  }

  static UserType _parseUserType(String? type) {
    switch (type?.toLowerCase()) {
      case 'athlete':
      case 'player':
        return UserType.athlete;
      case 'coach':
        return UserType.coach;
      case 'agent':
        return UserType.agent;
      case 'scout':
        return UserType.scout;
      default:
        return UserType.athlete;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'userType': userType.name,
      'location': location,
      'age': age,
    };
  }
}

enum UserType {
  athlete,
  coach,
  agent,
  scout,
}

class SearchFilters {
  final int? minAge;
  final int? maxAge;
  final String? location;
  final String? position;
  final String? typeOfPlay;
  final String? level;
  final UserType? userType;

  SearchFilters({
    this.minAge,
    this.maxAge,
    this.location,
    this.position,
    this.typeOfPlay,
    this.level,
    this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'minAge': minAge,
      'maxAge': maxAge,
      'location': location,
      'position': position,
      'typeOfPlay': typeOfPlay,
      'level': level,
      'userType': userType?.name,
    };
  }

  SearchFilters copyWith({
    int? minAge,
    int? maxAge,
    String? location,
    String? position,
    String? typeOfPlay,
    String? level,
    UserType? userType,
  }) {
    return SearchFilters(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      location: location ?? this.location,
      position: position ?? this.position,
      typeOfPlay: typeOfPlay ?? this.typeOfPlay,
      level: level ?? this.level,
      userType: userType ?? this.userType,
    );
  }
}