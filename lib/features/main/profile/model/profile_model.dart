class ProfileModel {
  final String id;
  final String name;
  final String? profileImage;
  final String role;
  final String description;
  final UserType userType;
  final ProfileStats stats;
  final List<Post> posts;
  final List<Achievement> achievements;
  final List<AnalyzedVideoReport> analyzedVideos;
  final List<Interest> interests;
  final List<Opportunity>? opportunities;
  final List<Course>? courses;
  final PlayerSpecificData? playerData;
  final CoachSpecificData? coachData;
  final ScoutSpecificData? scoutData;
  final ClubSpecificData? clubData;
  final InstituteSpecificData? instituteData;
  final OtherSpecificData? otherData;
  final bool isConnected; // Track if current user is connected to this profile
  final bool isFollowing; // Track if current user is following this profile

  ProfileModel({
    required this.id,
    required this.name,
    this.profileImage,
    required this.role,
    required this.description,
    required this.userType,
    required this.stats,
    required this.posts,
    required this.achievements,
    required this.analyzedVideos,
    required this.interests,
    this.opportunities,
    this.courses,
    this.playerData,
    this.coachData,
    this.scoutData,
    this.clubData,
    this.instituteData,
    this.otherData,
    this.isConnected = false,
    this.isFollowing = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userType = _parseUserType(json['userType'] ?? json['user_type']);

    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'],
      role: json['role'] ?? '',
      description: json['description'] ?? '',
      userType: userType,
      stats: ProfileStats.fromJson(json['stats'] ?? {}),
      posts:
          (json['posts'] as List?)?.map((e) => Post.fromJson(e)).toList() ?? [],
      achievements:
          (json['achievements'] as List?)
              ?.map((e) => Achievement.fromJson(e))
              .toList() ??
          [],
      analyzedVideos:
          (json['analyzedVideos'] as List?)
              ?.map((e) => AnalyzedVideoReport.fromJson(e))
              .toList() ??
          [],
      interests:
          (json['interests'] as List?)
              ?.map((e) => Interest.fromJson(e))
              .toList() ??
          [],
      opportunities: json['opportunities'] != null
          ? (json['opportunities'] as List)
                .map((e) => Opportunity.fromJson(e))
                .toList()
          : null,
      courses: json['courses'] != null
          ? (json['courses'] as List).map((e) => Course.fromJson(e)).toList()
          : null,
      playerData: userType == UserType.player && json['playerData'] != null
          ? PlayerSpecificData.fromJson(json['playerData'])
          : null,
      coachData: userType == UserType.coach && json['coachData'] != null
          ? CoachSpecificData.fromJson(json['coachData'])
          : null,
      scoutData: userType == UserType.scout && json['scoutData'] != null
          ? ScoutSpecificData.fromJson(json['scoutData'])
          : null,
      clubData: userType == UserType.club && json['clubData'] != null
          ? ClubSpecificData.fromJson(json['clubData'])
          : null,
      instituteData:
          userType == UserType.institute && json['instituteData'] != null
          ? InstituteSpecificData.fromJson(json['instituteData'])
          : null,
      otherData: userType == UserType.other && json['otherData'] != null
          ? OtherSpecificData.fromJson(json['otherData'])
          : null,
      isConnected: json['isConnected'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
    );
  }

  static UserType _parseUserType(String? type) {
    switch (type?.toLowerCase()) {
      case 'player':
        return UserType.player;
      case 'coach':
        return UserType.coach;
      case 'scout':
        return UserType.scout;
      case 'club':
        return UserType.club;
      case 'institute':
        return UserType.institute;
      default:
        return UserType.other;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'role': role,
      'description': description,
      'userType': userType.name,
      'stats': stats.toJson(),
      'posts': posts.map((e) => e.toJson()).toList(),
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'analyzedVideos': analyzedVideos.map((e) => e.toJson()).toList(),
      'interests': interests.map((e) => e.toJson()).toList(),
      'opportunities': opportunities?.map((e) => e.toJson()).toList(),
      'courses': courses?.map((e) => e.toJson()).toList(),
      'playerData': playerData?.toJson(),
      'coachData': coachData?.toJson(),
      'scoutData': scoutData?.toJson(),
      'clubData': clubData?.toJson(),
      'instituteData': instituteData?.toJson(),
      'otherData': otherData?.toJson(),
      'isConnected': isConnected,
      'isFollowing': isFollowing,
    };
  }

ProfileModel copyWith({
  String? id,
  String? name,
  String? profileImage,
  String? role,
  String? description,
  UserType? userType,
  ProfileStats? stats,
  List<Post>? posts,
  List<Achievement>? achievements,
  List<AnalyzedVideoReport>? analyzedVideos,
  List<Interest>? interests,
  List<Opportunity>? opportunities,
  List<Course>? courses,
  PlayerSpecificData? playerData,
  CoachSpecificData? coachData,
  ScoutSpecificData? scoutData,
  ClubSpecificData? clubData,
  InstituteSpecificData? instituteData,
  OtherSpecificData? otherData,
  bool? isConnected,
  bool? isFollowing,
}) {
  return ProfileModel(
    id: id ?? this.id,
    name: name ?? this.name,
    profileImage: profileImage ?? this.profileImage,
    role: role ?? this.role,
    description: description ?? this.description,
    userType: userType ?? this.userType,
    stats: stats ?? this.stats,
    posts: posts ?? this.posts,
    achievements: achievements ?? this.achievements,
    analyzedVideos: analyzedVideos ?? this.analyzedVideos,
    interests: interests ?? this.interests,
    opportunities: opportunities ?? this.opportunities,
    courses: courses ?? this.courses,
    playerData: playerData ?? this.playerData,
    coachData: coachData ?? this.coachData,
    scoutData: scoutData ?? this.scoutData,
    clubData: clubData ?? this.clubData,
    instituteData: instituteData ?? this.instituteData,
    otherData: otherData ?? this.otherData,
    isConnected: isConnected ?? this.isConnected,
    isFollowing: isFollowing ?? this.isFollowing,
  );
}
}

enum UserType { player, coach, scout, club, institute, other }

class ProfileStats {
  final String followers;
  final String following;
  final String connections;
  final String analyzedPeople;

  ProfileStats({
    required this.followers,
    required this.following,
    required this.connections,
    required this.analyzedPeople,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      followers: json['followers']?.toString() ?? '0',
      following: json['following']?.toString() ?? '0',
      connections: json['connections']?.toString() ?? '0',
      analyzedPeople:
          json['analyzedPeople']?.toString() ??
          json['analyzed_people']?.toString() ??
          '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followers': followers,
      'following': following,
      'connections': connections,
      'analyzedPeople': analyzedPeople,
    };
  }
}

class Post {
  final String id;
  final String imageUrl;
  final String? title;

  Post({required this.id, required this.imageUrl, this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl, 'title': title};
  }
}

class Achievement {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime? date;

  Achievement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.date,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'date': date?.toIso8601String(),
    };
  }
}

class AnalyzedVideoReport {
  final String id;
  final String thumbnailUrl;
  final String duration;
  final String speed;
  final String distance;
  final String calories;

  AnalyzedVideoReport({
    required this.id,
    required this.thumbnailUrl,
    required this.duration,
    required this.speed,
    required this.distance,
    required this.calories,
  });

  factory AnalyzedVideoReport.fromJson(Map<String, dynamic> json) {
    return AnalyzedVideoReport(
      id: json['id'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '',
      duration: json['duration'] ?? '',
      speed: json['speed'] ?? '',
      distance: json['distance'] ?? '',
      calories: json['calories'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'speed': speed,
      'distance': distance,
      'calories': calories,
    };
  }
}

class Interest {
  final String id;
  final String name;
  final String role;
  final String profileImage;
  final bool isConnected;
  final bool isFollowing;

  Interest({
    required this.id,
    required this.name,
    required this.role,
    required this.profileImage,
    this.isConnected = false,
    this.isFollowing = false,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'] ?? '',
      isConnected: json['isConnected'] ?? json['is_connected'] ?? false,
      isFollowing: json['isFollowing'] ?? json['is_following'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'isConnected': isConnected,
      'isFollowing': isFollowing,
    };
  }
}

class Opportunity {
  final String id;
  final String imageUrl;
  final String? title;

  Opportunity({required this.id, required this.imageUrl, this.title});

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl, 'title': title};
  }
}

class Course {
  final String id;
  final String imageUrl;
  final String? title;

  Course({required this.id, required this.imageUrl, this.title});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl, 'title': title};
  }
}

class PlayerSpecificData {
  final String? position;
  final String? height;
  final String? weight;
  final String? preferredFoot;
  final String? age;
  final String? specializedSport;
  final int? yearsOfExperience;
  final int? gender;

  PlayerSpecificData(
    {this.gender, 
    this.position,
    this.height,
    this.weight,
    this.preferredFoot,
    this.age,
    this.specializedSport,
    this.yearsOfExperience,
  });

  factory PlayerSpecificData.fromJson(Map<String, dynamic> json) {
    return PlayerSpecificData(
      position: json['position'],
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      preferredFoot: json['preferredFoot'] ?? json['preferred_foot'],
      age: json['age']?.toString(),
      specializedSport: json['specializedSport'] ?? json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      gender:
          json['gender'] ?? json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'height': height,
      'weight': weight,
      'preferredFoot': preferredFoot,
      'age': age,
      'specializedSport': specializedSport,
      'yearsOfExperience': yearsOfExperience,
      'gender': gender
    };
  }
}

class CoachSpecificData {
  final String? specializedSport;
  final int? yearsOfExperience;
  final String? certifications;
  final String? age;
  final int? gender;


  CoachSpecificData({
    this.gender,
    this.specializedSport,
    this.yearsOfExperience,
    this.certifications,
    this.age,
  });

  factory CoachSpecificData.fromJson(Map<String, dynamic> json) {
    return CoachSpecificData(
      specializedSport: json['specializedSport'] ?? json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      certifications: json['certifications'],
      age: json['age']?.toString(),
      gender:
          json['gender'] ?? json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializedSport': specializedSport,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'age': age,
      'gender':gender
    };
  }
}

class ScoutSpecificData {
  final String? specializedSport;
  final int? yearsOfExperience;
  final String? organization;
  final int? gender;


  ScoutSpecificData({
    this.gender, 
    this.specializedSport,
    this.yearsOfExperience,
    this.organization,
  });

  factory ScoutSpecificData.fromJson(Map<String, dynamic> json) {
    return ScoutSpecificData(
      specializedSport: json['specializedSport'] ?? json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      organization: json['organization'],
      gender:
          json['gender'] ?? json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializedSport': specializedSport,
      'yearsOfExperience': yearsOfExperience,
      'organization': organization,
      'gender':gender
    };
  }
}

class ClubSpecificData {
  final String? location;
  final String? foundedYear;//TODO NEED TO MAKE IT TYPE DATE
  final String? sport;

  ClubSpecificData({this.location, this.foundedYear, this.sport});

  factory ClubSpecificData.fromJson(Map<String, dynamic> json) {
    return ClubSpecificData(
      location: json['location'],
      foundedYear: json['foundedYear'] ?? json['founded_year']?.toString(),
      sport: json['sport'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'location': location, 'foundedYear': foundedYear, 'sport': sport};
  }
}

class InstituteSpecificData {
  final String? location;
  final String? industry;
  final String? foundedYear;
  final String? accreditation;

  InstituteSpecificData({this.industry, this.location, this.foundedYear, this.accreditation});

  factory InstituteSpecificData.fromJson(Map<String, dynamic> json) {
    return InstituteSpecificData(
      location: json['location'],
      foundedYear: json['foundedYear'] ?? json['founded_year']?.toString(),
      accreditation: json['accreditation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'foundedYear': foundedYear,
      'accreditation': accreditation,
    };
  }
}

class OtherSpecificData {
  final Map<String, dynamic>? customData;
  final int? gender;

  OtherSpecificData({this.gender, this.customData});

  factory OtherSpecificData.fromJson(Map<String, dynamic> json) {
    return OtherSpecificData(
      customData: json['customData'] ?? json['custom_data'],
      gender:
          json['gender'] ?? json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'customData': customData,'gender': gender};
  }
}
