part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}


class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}


class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;

  const PostsLoaded({
    required this.posts,
    this.hasNextPage = false,
  });

  @override
  List<Object?> get props => [posts, hasNextPage];
}


class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}


