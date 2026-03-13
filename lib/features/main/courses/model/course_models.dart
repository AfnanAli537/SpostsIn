import 'dart:io';

class CourseModel {
  final String id;
  final String title;
  final String? description;
  final double price;
  final String? thumbnailUrl;
  final int sportTypeId;
  final DateTime? createdAt;
  final CourseOwner owner;
  final bool isEnrolled;
  final bool isOwner;
  final num progress;
  final int lessonsCount;
  final double totalDurationHours;
  final int enrolledUsersCount;

  CourseModel({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.thumbnailUrl,
    required this.sportTypeId,
    this.createdAt,
    required this.owner,
    required this.isEnrolled,
    required this.isOwner,
    required this.progress,
    required this.lessonsCount,
    required this.totalDurationHours,
    required this.enrolledUsersCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      sportTypeId: json['sportTypeId'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      owner: CourseOwner.fromJson(
        json['owner'] as Map<String, dynamic>? ?? {},
      ),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      isOwner: json['isOwner'] as bool? ?? false,
      progress: json['progress'] as num? ?? 0,
      lessonsCount: json['lessonsCount'] as int? ?? 0,
      totalDurationHours:
          (json['totalDurationHours'] as num?)?.toDouble() ?? 0.0,
      enrolledUsersCount: json['enrolledUsersCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
      'sportTypeId': sportTypeId,
      'createdAt': createdAt?.toIso8601String(),
      'owner': owner.toJson(),
      'isEnrolled': isEnrolled,
      'isOwner': isOwner,
      'progress': progress,
      'lessonsCount': lessonsCount,
      'totalDurationHours': totalDurationHours,
      'enrolledUsersCount': enrolledUsersCount,
    };
  }

  bool get isFree => price == 0;

  String get formattedDuration {
    if (totalDurationHours < 1) {
      final minutes = (totalDurationHours * 60).round();
      return '${minutes}min';
    }
    final hours = totalDurationHours.floor();
    final minutes = ((totalDurationHours - hours) * 60).round();
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}min';
  }
}

class CourseOwner {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;

  CourseOwner({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory CourseOwner.fromJson(Map<String, dynamic> json) {
    return CourseOwner(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

class LessonModel {
  final String id;
  final String title;
  final String? description;
  final String? videoUrl;
  final double duration;
  final int order;
  final bool isWatched;
  final double watchedTime;
  final double videoZoomScale;

  LessonModel({
    required this.id,
    required this.title,
    this.description,
    this.videoUrl,
    required this.duration,
    required this.order,
    required this.isWatched,
    required this.watchedTime,
    required this.videoZoomScale,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      videoUrl: json['videoUrl'] as String?,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      order: json['order'] as int? ?? 0,
      isWatched: json['isWatched'] as bool? ?? false,
      watchedTime: (json['watchedTime'] as num?)?.toDouble() ?? 0.0,
      videoZoomScale: (json['videoZoomScale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
      'isWatched': isWatched,
      'watchedTime': watchedTime,
      'videoZoomScale': videoZoomScale,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    double? duration,
    int? order,
    bool? isWatched,
    double? watchedTime,
    double? videoZoomScale,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      isWatched: isWatched ?? this.isWatched,
      watchedTime: watchedTime ?? this.watchedTime,
      videoZoomScale: videoZoomScale ?? this.videoZoomScale,
    );
  }

  String get formattedDuration {
    final totalSeconds = duration.round();
    if (totalSeconds < 60) return '${totalSeconds}s';
    if (totalSeconds < 3600) {
      final minutes = (totalSeconds / 60).floor();
      final seconds = totalSeconds % 60;
      if (seconds == 0) return '${minutes}min';
      return '${minutes}min ${seconds}s';
    }
    final hours = (totalSeconds / 3600).floor();
    final minutes = ((totalSeconds % 3600) / 60).floor();
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}min';
  }

  double get progressPercentage {
    if (duration == 0) return 0.0;
    return (watchedTime / duration * 100).clamp(0.0, 100.0);
  }

  int get durationInSeconds => duration.round();
  int get watchedTimeInSeconds => watchedTime.round();
}

class EnrolledUserModel {
  final DateTime enrolledAt;
  final num progress;
  final String userId;
  final String fullName;
  final String? profilePictureUrl;

  EnrolledUserModel({
    required this.enrolledAt,
    required this.progress,
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory EnrolledUserModel.fromJson(Map<String, dynamic> json) {
    return EnrolledUserModel(
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      progress: json['progress'] as num? ?? 0,
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrolledAt': enrolledAt.toIso8601String(),
      'progress': progress,
      'userId': userId,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

class RevenueReportModel {
  final double totalAllTimeRevenue;
  final double totalMonthRevenue;
  final List<WeeklyRevenueModel> weeklyBreakdown;
  final int month;
  final int year;

  RevenueReportModel({
    required this.totalAllTimeRevenue,
    required this.totalMonthRevenue,
    required this.weeklyBreakdown,
    required this.month,
    required this.year,
  });

  factory RevenueReportModel.fromJson(Map<String, dynamic> json) {
    return RevenueReportModel(
      totalAllTimeRevenue:
          (json['totalAllTimeRevenue'] as num?)?.toDouble() ?? 0.0,
      totalMonthRevenue:
          (json['totalMonthRevenue'] as num?)?.toDouble() ?? 0.0,
      weeklyBreakdown: (json['weeklyBreakdown'] as List<dynamic>?)
              ?.map((e) =>
                  WeeklyRevenueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAllTimeRevenue': totalAllTimeRevenue,
      'totalMonthRevenue': totalMonthRevenue,
      'weeklyBreakdown': weeklyBreakdown.map((e) => e.toJson()).toList(),
      'month': month,
      'year': year,
    };
  }
}

class WeeklyRevenueModel {
  final String weekLabel;
  final double revenue;

  WeeklyRevenueModel({required this.weekLabel, required this.revenue});

  factory WeeklyRevenueModel.fromJson(Map<String, dynamic> json) {
    return WeeklyRevenueModel(
      weekLabel: json['weekLabel'] as String? ?? '',
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'weekLabel': weekLabel, 'revenue': revenue};
}

class PaginatedCoursesResponse {
  final List<CourseModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedCoursesResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedCoursesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCoursesResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
}

class CreateCourseRequest {
  final String title;
  final String description;
  final double price;
  final int sportTypeId;
  final File? thumbnailFile;

  CreateCourseRequest({
    required this.title,
    required this.description,
    required this.price,
    required this.sportTypeId,
    this.thumbnailFile,
  });
}

class UpdateCourseRequest {
  final String id;
  final String title;
  final String description;
  final double price;
  final int sportTypeId;
  final dynamic thumbnail;

  UpdateCourseRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sportTypeId,
    this.thumbnail,
  });
}

class CreateLessonRequest {
  final String title;
  final String description;
  final double duration;
  final int? order;
  final File videoFile;

  CreateLessonRequest({
    required this.title,
    required this.description,
    required this.duration,
    this.order,
    required this.videoFile,
  });
}

class UpdateLessonRequest {
  final String lessonId;
  final String title;
  final String description;
  final double duration;
  final int order;
  final dynamic video;

  UpdateLessonRequest({
    required this.lessonId,
    required this.title,
    required this.description,
    required this.duration,
    required this.order,
    this.video,
  });
}

class UpdateProgressRequest {
  final double watchedTime;
  final bool isWatched;
  final double zoomScale;

  UpdateProgressRequest({
    required this.watchedTime,
    required this.isWatched,
    this.zoomScale = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'watchedTime': watchedTime,
      'isWatched': isWatched,
      'zoomScale': zoomScale,
    };
  }
}