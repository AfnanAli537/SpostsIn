import 'package:sports_in/features/main/home/data/model/author_model.dart';

class PostModel {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final String? mediaUrl;
  final DateTime createdAt;
  final AuthorModel author;
  int likesCount;
  int commentsCount;
  bool isLikedByCurrentUser;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.mediaUrl,
    required this.createdAt,
    required this.author,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByCurrentUser,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isActive: json['isActive'],
      mediaUrl: json['mediaUrl']??'',
      createdAt: DateTime.parse(json['createdAt']),
      author: AuthorModel.fromJson(json['author']),
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      isLikedByCurrentUser: json['isLikedByCurrentUser'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isActive': isActive,
        'mediaUrl': mediaUrl,
        'createdAt': createdAt.toIso8601String(),
        'author': author.toJson(),
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'isLikedByCurrentUser': isLikedByCurrentUser,
      };

  PostModel copyWith({
    String? title,
    String? description,
    int? likesCount,
    int? commentsCount,
    bool? isLikedByCurrentUser,
  }) {
    return PostModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive,
      mediaUrl: mediaUrl,
      createdAt: createdAt,
      author: author,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}

