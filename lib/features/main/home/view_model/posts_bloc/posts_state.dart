part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;
  final bool isUploading;

  PostsLoaded({
    required this.posts,
    required this.hasNextPage,
    this.isUploading = false,
  });

  @override
  List<Object?> get props => [posts, hasNextPage, isUploading];
}

// ✅ New state for user-specific posts
class UserPostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;

  UserPostsLoaded({
    required this.posts,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [posts, hasNextPage];
}

class PostsError extends PostsState {
  final String message;

  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostsUploadSuccess extends PostsState {}

// ✅ New state for update success
class PostUpdateSuccess extends PostsState {}

  @override
  List<Object?> get props => [posts, hasNextPage, isUploading];
}
class PostsLoadingMore extends PostsState {
  final List<PostModel> currentPosts;

  const PostsLoadingMore(this.currentPosts);

  @override
  List<Object?> get props => [currentPosts];
}
// ✅ New state for delete success
class PostDeleteSuccess extends PostsState {}
