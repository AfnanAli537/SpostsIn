part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}


class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}




class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}


// في posts_state.dart

class PostsUploading extends PostsState {
  final List<PostModel> currentPosts;
  
  const PostsUploading(this.currentPosts);
  
  @override
  List<Object?> get props => [currentPosts];
}

class PostsUploadSuccess extends PostsState {
  const PostsUploadSuccess();
  
  @override
  List<Object?> get props => [];
}
 // ✅ إضافة isUploading للـ PostsLoaded
class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasNextPage;
  final bool isUploading; // ✅ جديد

  const PostsLoaded({
    required this.posts,
    required this.hasNextPage,
    this.isUploading = false, // ✅ default false
  });

  @override
  List<Object?> get props => [posts, hasNextPage, isUploading];
}

