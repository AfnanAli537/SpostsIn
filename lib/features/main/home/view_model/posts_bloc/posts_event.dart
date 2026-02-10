part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostsEvent {
  final int page;

  const FetchPosts({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LikePost extends PostsEvent {
  final String postId;

  const LikePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class UploadPost extends PostsEvent {
  final String title;
  final String description;
  final String sport;
  final String? mediaUrl;

  const UploadPost({
    required this.title,
    required this.description,
    required this.sport,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [title, description, sport];
}

class FetchUserPosts extends PostsEvent {
  final String userId;
  final int page;
  final int pageSize;

  FetchUserPosts({
    required this.userId,
    this.page = 1,
    this.pageSize = 10,
  });
  }

class UpdatePost extends PostsEvent {
  final String postId;
  final String title;
  final String description;
  final int sportTypeId;
  final String? mediaFile; // Path to new media file (optional)

  UpdatePost({
    required this.postId,
    required this.title,
    required this.description,
    required this.sportTypeId,
    this.mediaFile,
  });

  @override
  List<Object?> get props => [postId, title, description, sportTypeId, mediaFile];
}

class DeletePost extends PostsEvent {
  final String postId;

  DeletePost({required this.postId});

  @override
  List<Object?> get props => [postId];
}