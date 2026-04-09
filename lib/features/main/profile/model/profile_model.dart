import 'package:sports_in/core/mappers/enum_mapper.dart';

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
  // ── Active ads shown on the profile ──────────────────────────────────────
  final List<ProfileAd> ads;
  final PlayerSpecificData? playerData;
  final CoachSpecificData? coachData;
  final ScoutSpecificData? scoutData;
  final ClubSpecificData? clubData;
  final InstituteSpecificData? instituteData;
  final OtherSpecificData? otherData;

  /// null = not connected, "Pending" = request sent awaiting accept, "Accepted" = in contacts
  final String? connectionStatus;
  final bool isFollowing;
  final bool isOwner;

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
    this.ads = const [], // ← default empty; optional for callers
    this.playerData,
    this.coachData,
    this.scoutData,
    this.clubData,
    this.instituteData,
    this.otherData,
    this.connectionStatus,
    this.isFollowing = false,
    this.isOwner = false,
  });

  /// Convenience getters
  bool get isConnected => connectionStatus == 'Accepted';
  bool get isPending => connectionStatus == 'Pending';

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
      ads:
          (json['ads'] as List?)?.map((e) => ProfileAd.fromJson(e)).toList() ??
          [],
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
      connectionStatus: json['connectionStatus'] as String?,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isOwner: json['isOwner'] as bool? ?? false,
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
      'ads': ads.map((e) => e.toJson()).toList(),
      'playerData': playerData?.toJson(),
      'coachData': coachData?.toJson(),
      'scoutData': scoutData?.toJson(),
      'clubData': clubData?.toJson(),
      'instituteData': instituteData?.toJson(),
      'otherData': otherData?.toJson(),
      'connectionStatus': connectionStatus,
      'isFollowing': isFollowing,
      'isOwner': isOwner,
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
    List<ProfileAd>? ads, // ← new
    PlayerSpecificData? playerData,
    CoachSpecificData? coachData,
    ScoutSpecificData? scoutData,
    ClubSpecificData? clubData,
    InstituteSpecificData? instituteData,
    OtherSpecificData? otherData,
    String? connectionStatus,
    bool? isFollowing,
    bool? isOwner,
    bool clearConnectionStatus = false,
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
      ads: ads ?? this.ads, // ← new
      playerData: playerData ?? this.playerData,
      coachData: coachData ?? this.coachData,
      scoutData: scoutData ?? this.scoutData,
      clubData: clubData ?? this.clubData,
      instituteData: instituteData ?? this.instituteData,
      otherData: otherData ?? this.otherData,
      connectionStatus: clearConnectionStatus
          ? null
          : (connectionStatus ?? this.connectionStatus),
      isFollowing: isFollowing ?? this.isFollowing,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}

enum UserType { player, coach, scout, club, institute, other }

// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────

class Post {
  final String id;
  final String imageUrl;
  final String? title;
  final String? description;

  Post({
    required this.id,
    required this.imageUrl,
    this.title,
    this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
    };
  }
}

class ProfileAd {
  final String id;
  final String title;
  final String? mediaUrl;
  final bool isActive;

  const ProfileAd({
    required this.id,
    required this.title,
    this.mediaUrl,
    required this.isActive,
  });

  factory ProfileAd.fromJson(Map<String, dynamic> json) {
    return ProfileAd(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      mediaUrl: json['mediaUrl'],
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'mediaUrl': mediaUrl,
    'isActive': isActive,
  };
}

// ─────────────────────────────────────────────────────────────────────────────

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
  final String type; // "Goalkeeper" | "Passing" | "Dribbling" | "Match"
  final String createdAt;
  final String originalVideoUrl;
  final String? analyzedVideoUrl;
  final bool isPaid;
  final String playerName;
  final String? playerAvatar;
  final String analystName;

  const AnalyzedVideoReport({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.originalVideoUrl,
    this.analyzedVideoUrl,
    required this.isPaid,
    required this.playerName,
    this.playerAvatar,
    required this.analystName,
  });

  /// Parses one item from /api/Analysis/search/library or /search/public
  factory AnalyzedVideoReport.fromJson(Map<String, dynamic> json) {
    final player = json['player'] as Map<String, dynamic>? ?? {};
    final analyst = json['analyst'] as Map<String, dynamic>? ?? {};
    return AnalyzedVideoReport(
      id: json['id'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] as String,
      originalVideoUrl: json['originalVideoUrl'] as String,
      analyzedVideoUrl: json['analyzedVideoUrl'] as String?,
      isPaid: json['isPaid'] as bool,
      playerName: player['fullName'] as String? ?? '',
      playerAvatar: player['profilePicture'] as String?,
      analystName: analyst['fullName'] as String? ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'createdAt': createdAt,
      'originalVideoUrl': originalVideoUrl,
      'analyzedVideoUrl': analyzedVideoUrl,
      'isPaid': isPaid,
      'playerName': playerName,
      'playerAvatar': playerAvatar,
      'analystName': analystName,
    };
  }
}
// ─────────────────────────────────────────────────────────────────────────────

class Interest {
  final String id;
  final String name;
  final String role;
  final String profileImage;

  /// null = not connected, "Pending" = request sent, "Accepted" = in contacts
  final String? connectionStatus;
  final bool isFollowing;

  bool get isConnected => connectionStatus == 'Accepted';

  Interest({
    required this.id,
    required this.name,
    required this.role,
    required this.profileImage,
    this.connectionStatus,
    this.isFollowing = false,
  });

  Interest copyWith({
    String? id,
    String? name,
    String? role,
    String? profileImage,
    String? connectionStatus,
    bool? isFollowing,
    bool clearConnectionStatus = false,
  }) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      connectionStatus: clearConnectionStatus
          ? null
          : (connectionStatus ?? this.connectionStatus),
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'] ?? '',
      connectionStatus: json['connectionStatus'] as String?,
      isFollowing: json['isFollowing'] ?? json['is_following'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'connectionStatus': connectionStatus,
      'isFollowing': isFollowing,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class Opportunity {
  final String id;
  final String mediaUrl;
  final String? title;

  Opportunity({required this.id, required this.mediaUrl, this.title});

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'mediaUrl': mediaUrl, 'title': title};
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class Course {
  final String id;
  final String imageUrl;
  final String? title;
  final String? description;
  final double? price;
  final bool isFree;
  final int lessonsCount;
  final int enrolledCount;

  Course({
    required this.id,
    required this.imageUrl,
    this.title,
    this.description,
    this.price,
    this.isFree = false,
    this.lessonsCount = 0,
    this.enrolledCount = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      imageUrl: json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '',
      title: json['title'],
      description: json['description'],
      price: json['price']?.toDouble(),
      isFree: json['isFree'] ?? false,
      lessonsCount: json['lessonsCount'] ?? 0,
      enrolledCount: json['enrolledUsersCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
      'lessonsCount': lessonsCount,
      'enrolledCount': enrolledCount,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class PlayerSpecificData {
  final String? position;
  final String? height;
  final String? weight;
  final String? preferredFoot;
  final String? age;
  final String? specializedSport;
  final int? yearsOfExperience;
  final int? gender;

  PlayerSpecificData({
    this.gender,
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
      specializedSport:
          EnumMapper.sportIdToLabel(json['sports']) ??
          json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      gender: json['gender'],
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
      'gender': gender,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
      specializedSport:
          EnumMapper.sportIdToLabel(json['sports']) ??
          json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      certifications: json['certifications'],
      age: json['age']?.toString(),
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializedSport': specializedSport,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'age': age,
      'gender': gender,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
      specializedSport:
          EnumMapper.sportIdToLabel(json['sports']) ??
          json['specialized_sport'],
      yearsOfExperience:
          json['yearsOfExperience'] ?? json['years_of_experience'],
      organization: json['organization'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specializedSport': specializedSport,
      'yearsOfExperience': yearsOfExperience,
      'organization': organization,
      'gender': gender,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ClubSpecificData {
  final String? location;
  final String? foundedYear;
  final List<String?>? sport;

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

// ─────────────────────────────────────────────────────────────────────────────

class InstituteSpecificData {
  final String? location;
  final String? industry;
  final String? foundedYear;
  final String? accreditation;

  InstituteSpecificData({
    this.industry,
    this.location,
    this.foundedYear,
    this.accreditation,
  });

  factory InstituteSpecificData.fromJson(Map<String, dynamic> json) {
    return InstituteSpecificData(
      location: json['location'],
      industry: json['industry'],
      foundedYear: json['foundedYear'] ?? json['founded_year']?.toString(),
      accreditation: json['accreditation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'industry': industry,
      'foundedYear': foundedYear,
      'accreditation': accreditation,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class OtherSpecificData {
  final Map<String, dynamic>? customData;
  final int? gender;

  OtherSpecificData({this.gender, this.customData});

  factory OtherSpecificData.fromJson(Map<String, dynamic> json) {
    return OtherSpecificData(
      customData: json['customData'] ?? json['custom_data'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'customData': customData, 'gender': gender};
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ConnectionRequest {
  final String id;
  final String fullName;
  final String? profilePictureUrl;

  const ConnectionRequest({
    required this.id,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ContactItem {
  final String id;
  final String title;
  final String? imageUrl;
  final bool isOnline;

  const ContactItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.isOnline = false,
  });

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}

class UserContactItem {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;
  final String userType; // e.g., "User"
  final String? bio;
  final bool isFollowedByMe;
  final String?
  connectionStatus; // or maybe an enum, depending on possible values

  const UserContactItem({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
    required this.userType,
    this.bio,
    required this.isFollowedByMe,
    this.connectionStatus,
  });

  factory UserContactItem.fromJson(Map<String, dynamic> json) {
    return UserContactItem(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
      userType: json['userType'] ?? '',
      bio: json['bio'] as String?,
      isFollowedByMe: json['isFollowedByMe'] as bool? ?? false,
      connectionStatus: json['connectionStatus'] as String?,
    );
  }
  UserContactItem copyWith({
    String? userId,
    String? fullName,
    String? profilePictureUrl,
    String? userType,
    String? bio,
    bool? isFollowedByMe,
    String? connectionStatus,
  }) {
    return UserContactItem(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      userType: userType ?? this.userType,
      bio: bio ?? this.bio,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      connectionStatus:
          connectionStatus,
    );
  }
}
