part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;
  final bool isUploading;

  const PostsLoaded({
    required this.posts,
    required this.hasNextPage,
    this.isUploading = false,
  });

  @override
  List<Object?> get props => [posts, hasNextPage, isUploading];
}

class UserPostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;
  final bool isUploading;

  const UserPostsLoaded({
    required this.posts,
    required this.hasNextPage,
    this.isUploading = false,
  });

  @override
  List<Object?> get props => [posts, hasNextPage, isUploading];
}

class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostsUploadSuccess extends PostsState {}

class PostUpdateSuccess extends PostsState {}

class PostDeleteSuccess extends PostsState {}

class PostArchivedSuccess extends PostsState {}

class PostsLoadingMore extends PostsState {
  final List<PostModel> currentPosts;

  const PostsLoadingMore(this.currentPosts);

  @override
  List<Object?> get props => [currentPosts];
}
