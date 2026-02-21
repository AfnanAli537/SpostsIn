class CourseModel {
  final String courseId;
  final String title;
  final String? thumbnailUrl;
  final String sport;
  final String level;
  final int totalLessons;
  final String? totalDurationFormatted;
  final int enrolledCount;
  final double rating;
  final int? reviewCount;
  final double price;
  final String currency;
  final bool isFree;
  final bool isEnrolled;
  final CourseProvider provider;
  final String? description;
  final int? completedLessons;
  final int? progressPercent;
  final DateTime? enrolledAt;
  final DateTime? lastAccessedAt;
  final DateTime? createdAt;
  final double? totalRevenue; // Only for owner
  final String? status; // draft, published

  CourseModel({
    required this.courseId,
    required this.title,
    this.thumbnailUrl,
    required this.sport,
    required this.level,
    required this.totalLessons,
    this.totalDurationFormatted,
    required this.enrolledCount,
    this.rating = 0.0,
    this.reviewCount,
    required this.price,
    required this.currency,
    required this.isFree,
    required this.isEnrolled,
    required this.provider,
    this.description,
    this.completedLessons,
    this.progressPercent,
    this.enrolledAt,
    this.lastAccessedAt,
    this.createdAt,
    this.totalRevenue,
    this.status,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      sport: json['sport'] as String? ?? '',
      level: json['level'] as String? ?? '',
      totalLessons: json['totalLessons'] as int? ?? 0,
      totalDurationFormatted: json['totalDurationFormatted'] as String?,
      enrolledCount: json['enrolledCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EGP',
      isFree: json['isFree'] as bool? ?? false,
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      provider: CourseProvider.fromJson(
        json['provider'] as Map<String, dynamic>? ?? {},
      ),
      description: json['description'] as String?,
      completedLessons: json['completedLessons'] as int?,
      progressPercent: json['progressPercent'] as int?,
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'] as String)
          : null,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'sport': sport,
      'level': level,
      'totalLessons': totalLessons,
      'totalDurationFormatted': totalDurationFormatted,
      'enrolledCount': enrolledCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'currency': currency,
      'isFree': isFree,
      'isEnrolled': isEnrolled,
      'provider': provider.toJson(),
      'description': description,
      'completedLessons': completedLessons,
      'progressPercent': progressPercent,
      'enrolledAt': enrolledAt?.toIso8601String(),
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'totalRevenue': totalRevenue,
      'status': status,
    };
  }
}

class CourseProvider {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;
  final String userType;
  final bool isVerified;

  CourseProvider({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
    required this.userType,
    this.isVerified = false,
  });

  factory CourseProvider.fromJson(Map<String, dynamic> json) {
    return CourseProvider(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
      userType: json['userType'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
      'userType': userType,
      'isVerified': isVerified,
    };
  }
}

class LessonModel {
  final String lessonId;
  final int order;
  final String title;
  final String durationFormatted;
  final int durationSeconds;
  final String? videoUrl;
  final String? thumbnailUrl;
  final bool isWatched;
  final int watchedDurationSeconds;
  final bool? isPreview;
  final DateTime? completedAt;

  LessonModel({
    required this.lessonId,
    required this.order,
    required this.title,
    required this.durationFormatted,
    required this.durationSeconds,
    this.videoUrl,
    this.thumbnailUrl,
    this.isWatched = false,
    this.watchedDurationSeconds = 0,
    this.isPreview,
    this.completedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      lessonId: json['lessonId'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      durationFormatted: json['durationFormatted'] as String? ?? '00:00',
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isWatched: json['isWatched'] as bool? ?? false,
      watchedDurationSeconds: json['watchedDurationSeconds'] as int? ?? 0,
      isPreview: json['isPreview'] as bool?,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'order': order,
      'title': title,
      'durationFormatted': durationFormatted,
      'durationSeconds': durationSeconds,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'isWatched': isWatched,
      'watchedDurationSeconds': watchedDurationSeconds,
      'isPreview': isPreview,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  double get progressPercentage {
    if (durationSeconds == 0) return 0.0;
    return (watchedDurationSeconds / durationSeconds * 100).clamp(0.0, 100.0);
  }
}

class EnrolleeModel {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;
  final String userType;
  final String role;
  final DateTime joinDate;
  final int progressPercent;
  final int completedLessons;
  final String performanceLabel;

  EnrolleeModel({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
    required this.userType,
    required this.role,
    required this.joinDate,
    required this.progressPercent,
    required this.completedLessons,
    required this.performanceLabel,
  });

  factory EnrolleeModel.fromJson(Map<String, dynamic> json) {
    return EnrolleeModel(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
      userType: json['userType'] as String? ?? '',
      role: json['role'] as String? ?? '',
      joinDate: DateTime.parse(json['joinDate'] as String),
      progressPercent: json['progressPercent'] as int? ?? 0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      performanceLabel: json['performanceLabel'] as String? ?? '',
    );
  }
}

class RevenueTimelineModel {
  final String courseId;
  final String period;
  final double totalEarnings;
  final String currency;
  final int totalEnrolled;
  final List<RevenueDataPoint> timeline;

  RevenueTimelineModel({
    required this.courseId,
    required this.period,
    required this.totalEarnings,
    required this.currency,
    required this.totalEnrolled,
    required this.timeline,
  });

  factory RevenueTimelineModel.fromJson(Map<String, dynamic> json) {
    return RevenueTimelineModel(
      courseId: json['courseId'] as String? ?? '',
      period: json['period'] as String? ?? 'month',
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EGP',
      totalEnrolled: json['totalEnrolled'] as int? ?? 0,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => RevenueDataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RevenueDataPoint {
  final String label;
  final int enrollments;
  final double revenueEGP;

  RevenueDataPoint({
    required this.label,
    required this.enrollments,
    required this.revenueEGP,
  });

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) {
    return RevenueDataPoint(
      label: json['label'] as String? ?? '',
      enrollments: json['enrollments'] as int? ?? 0,
      revenueEGP: (json['revenueEGP'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PaginatedCoursesResponse {
  final List<CourseModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool? isOwner; // For provider's uploaded courses

  PaginatedCoursesResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    this.isOwner,
  });

  factory PaginatedCoursesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCoursesResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
      isOwner: json['isOwner'] as bool?,
    );
  }
}

class PaginatedLessonsResponse {
  final String courseId;
  final bool isEnrolled;
  final List<LessonModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedLessonsResponse({
    required this.courseId,
    required this.isEnrolled,
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedLessonsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedLessonsResponse(
      courseId: json['courseId'] as String? ?? '',
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class PaginatedEnrolleesResponse {
  final String courseId;
  final String courseTitle;
  final int totalEnrolled;
  final List<EnrolleeModel> items;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedEnrolleesResponse({
    required this.courseId,
    required this.courseTitle,
    required this.totalEnrolled,
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedEnrolleesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedEnrolleesResponse(
      courseId: json['courseId'] as String? ?? '',
      courseTitle: json['courseTitle'] as String? ?? '',
      totalEnrolled: json['totalEnrolled'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => EnrolleeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}