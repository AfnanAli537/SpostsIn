part of 'likes_bloc.dart';

sealed class LikesState extends Equatable {
  const LikesState();

  @override
  List<Object?> get props => [];
}

class LikesInitial extends LikesState {}

class LikesLoading extends LikesState {}

class LikesLoaded extends LikesState {
  final List<UserLists> likes;
  final bool hasMore;
  final int currentPage;

  const LikesLoaded({
    required this.likes,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [likes, hasMore, currentPage];
}

class LikesError extends LikesState {
  final String message;

  const LikesError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikesLoadingMore extends LikesState {
  final List<UserLists> currentLikes;

  const LikesLoadingMore(this.currentLikes);

  @override
  List<Object?> get props => [currentLikes];
}