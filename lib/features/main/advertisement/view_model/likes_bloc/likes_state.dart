part of 'likes_bloc.dart';

sealed class AdLikesState extends Equatable {
  const AdLikesState();
  @override
  List<Object?> get props => [];
}

class AdLikesInitial extends AdLikesState {}

class AdLikesLoading extends AdLikesState {}

class AdLikesLoaded extends AdLikesState {
  final List<UserLists> likes;
  final bool hasMore;
  final int currentPage;

  const AdLikesLoaded({
    required this.likes,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [likes, hasMore, currentPage];
}

class AdLikesLoadingMore extends AdLikesState {
  final List<UserLists> currentLikes;
  const AdLikesLoadingMore(this.currentLikes);

  @override
  List<Object?> get props => [currentLikes];
}

class AdLikesError extends AdLikesState {
  final String message;
  const AdLikesError(this.message);

  @override
  List<Object?> get props => [message];
}