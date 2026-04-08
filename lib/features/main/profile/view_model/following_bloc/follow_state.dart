part of 'follow_bloc.dart';



abstract class FollowingState {}
class FollowingInitial extends FollowingState {}
class FollowingLoading extends FollowingState {}
class FollowingLoaded extends FollowingState {
  final List<UserContactItem> items;
  final bool hasNextPage;
  final bool isLoadingMore;
  final int currentPage;
  FollowingLoaded({
    required this.items,
    required this.hasNextPage,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });
  FollowingLoaded copyWith({List<UserContactItem>? items, bool? hasNextPage, bool? isLoadingMore, int? currentPage}) {
    return FollowingLoaded(
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
class FollowingError extends FollowingState {
  final String message;
  FollowingError(this.message);
}
