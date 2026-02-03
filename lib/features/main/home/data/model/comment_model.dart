

// comment_model.dart
class CommentModel {
  final String commentId;
  final String text;
  final DateTime createdAt;
  final String userId;
  final String fullName;
  final String? profilePictureUrl;

  CommentModel({
    required this.commentId,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? 'Unknown User',
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'fullName': fullName,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? text,
    DateTime? createdAt,
    String? userId,
    String? fullName,
    String? profilePictureUrl,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}

// ✅ Paginated Response Model
class PaginatedCommentsResponse {
  final List<CommentModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedCommentsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedCommentsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCommentsResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => CommentModel.fromJson(item))
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