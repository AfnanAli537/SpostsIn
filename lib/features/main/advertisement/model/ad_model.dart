import 'package:sports_in/features/main/home/data/model/author_model.dart';

class AdModel {
  final String id;
  final String title;
  final String description;
  final String? mediaUrl;
  final double price;
  final String? actionUrl;
  final String? actionText;
  final DateTime startDate;
  final DateTime endDate;
  final int sportTypeId;
  final String? sportTypeName;
  final double videoDuration;
  final List<int> targetAudiences;
  final bool isActive;
  final bool isPaid;
  final double watchedTime;
  final bool isWatched;
  final double videoZoomScale;
  final DateTime? lastWatchedAt;
  final int viewCount;
  final int clickCount;
  int likesCount;
  int commentsCount;
  bool isLikedByCurrentUser;
  final AuthorModel? author;

  AdModel({
    required this.id,
    required this.title,
    required this.description,
    this.mediaUrl,
    required this.price,
    this.actionUrl,
    this.actionText,
    required this.startDate,
    required this.endDate,
    required this.sportTypeId,
    this.sportTypeName,
    required this.videoDuration,
    required this.targetAudiences,
    required this.isActive,
    required this.isPaid,
    required this.watchedTime,
    required this.isWatched,
    required this.videoZoomScale,
    this.lastWatchedAt,
    required this.viewCount,
    required this.clickCount,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByCurrentUser,
    this.author,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mediaUrl: json['mediaUrl'],
      price: (json['price'] ?? 0).toDouble(),
      actionUrl: json['actionUrl'],
      actionText: json['actionText'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      sportTypeId: (json['sportTypeId'] ?? 1).toInt(),
      sportTypeName: json['sportTypeName'],
      videoDuration: (json['videoDuration'] ?? 0).toDouble(),
      targetAudiences: List<int>.from(
          (json['targetAudiences'] ?? []).map((e) => (e as num).toInt())),
      isActive: json['isActive'] ?? false,
      isPaid: json['isPaid'] ?? false,
      watchedTime: (json['watchedTime'] ?? 0).toDouble(),
      isWatched: json['isWatched'] ?? false,
      videoZoomScale: (json['videoZoomScale'] ?? 1).toDouble(),
      lastWatchedAt: json['lastWatchedAt'] != null
          ? DateTime.parse(json['lastWatchedAt'])
          : null,
      viewCount: (json['viewCount'] ?? 0).toInt(),
      clickCount: (json['clickCount'] ?? 0).toInt(),
      likesCount: (json['likesCount'] ?? 0).toInt(),
      commentsCount: (json['commentsCount'] ?? 0).toInt(),
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'mediaUrl': mediaUrl,
        'price': price,
        'actionUrl': actionUrl,
        'actionText': actionText,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'sportTypeId': sportTypeId,
        'sportTypeName': sportTypeName,
        'videoDuration': videoDuration,
        'targetAudiences': targetAudiences,
        'isActive': isActive,
        'isPaid': isPaid,
        'watchedTime': watchedTime,
        'isWatched': isWatched,
        'videoZoomScale': videoZoomScale,
        'lastWatchedAt': lastWatchedAt?.toIso8601String(),
        'viewCount': viewCount,
        'clickCount': clickCount,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'isLikedByCurrentUser': isLikedByCurrentUser,
        'author': author?.toJson(),
      };

  AdModel copyWith({
    int? likesCount,
    int? commentsCount,
    bool? isLikedByCurrentUser,
  }) {
    return AdModel(
      id: id,
      title: title,
      description: description,
      mediaUrl: mediaUrl,
      price: price,
      actionUrl: actionUrl,
      actionText: actionText,
      startDate: startDate,
      endDate: endDate,
      sportTypeId: sportTypeId,
      sportTypeName: sportTypeName,
      videoDuration: videoDuration,
      targetAudiences: targetAudiences,
      isActive: isActive,
      isPaid: isPaid,
      watchedTime: watchedTime,
      isWatched: isWatched,
      videoZoomScale: videoZoomScale,
      lastWatchedAt: lastWatchedAt,
      viewCount: viewCount,
      clickCount: clickCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      author: author,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdModel &&
        other.id == id &&
        other.isLikedByCurrentUser == isLikedByCurrentUser &&
        other.likesCount == likesCount &&
        other.commentsCount == commentsCount &&
        other.isActive == isActive &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode => Object.hash(
        id,
        isLikedByCurrentUser,
        likesCount,
        commentsCount,
        isActive,
        isPaid,
      );
}

class AdDashboardModel {
  final int totalAds;
  final int totalViews;
  final int totalClicks;
  final double averageCompletionRate;
  final int totalEngagementSeconds;

  AdDashboardModel({
    required this.totalAds,
    required this.totalViews,
    required this.totalClicks,
    required this.averageCompletionRate,
    required this.totalEngagementSeconds,
  });

  factory AdDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdDashboardModel(
      totalAds: (json['totalAds'] ?? 0).toInt(),
      totalViews: (json['totalViews'] ?? 0).toInt(),
      totalClicks: (json['totalClicks'] ?? 0).toInt(),
      averageCompletionRate:
          (json['averageCompletionRate'] ?? 0).toDouble(),
      totalEngagementSeconds:
          (json['totalEngagementSeconds'] ?? 0).toInt(),
    );
  }
}

class PaginatedAdsResponse {
  final List<AdModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedAdsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedAdsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedAdsResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => AdModel.fromJson(item))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}