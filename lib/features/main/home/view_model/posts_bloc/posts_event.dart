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

class AddComment extends PostsEvent {
  final String postId;
  final String comment;

  const AddComment({required this.postId, required this.comment});

  @override
  List<Object?> get props => [postId, comment];
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
