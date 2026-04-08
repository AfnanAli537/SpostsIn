part of 'follow_bloc.dart';



abstract class FollowersState {}
class FollowersInitial extends FollowersState {}
class FollowersLoading extends FollowersState {}
class FollowersLoaded extends FollowersState {
  final List<UserContactItem> items;
  final bool hasNextPage;
  final bool isLoadingMore;
  final int currentPage;
  FollowersLoaded({
    required this.items,
    required this.hasNextPage,
    this.isLoadingMore = false,
    this.currentPage = 1,
  });
  FollowersLoaded copyWith({List<UserContactItem>? items, bool? hasNextPage, bool? isLoadingMore, int? currentPage}) {
    return FollowersLoaded(
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
class FollowersError extends FollowersState {
  final String message;
  FollowersError(this.message);
}
