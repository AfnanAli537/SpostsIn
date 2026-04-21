part of 'follow_bloc.dart';
abstract class FollowListState {}
class FollowListInitial extends FollowListState {}
class FollowListLoading extends FollowListState {}
class FollowListLoaded extends FollowListState {
  final List<UserContactItem> items;
  final bool hasNextPage;
  final bool isLoadingMore;
  final int currentPage;
  final FollowListType type;

  FollowListLoaded({
    required this.items,
    required this.hasNextPage,
    this.isLoadingMore = false,
    this.currentPage = 1,
    required this.type,
  });

  FollowListLoaded copyWith({
    List<UserContactItem>? items,
    bool? hasNextPage,
    bool? isLoadingMore,
    int? currentPage,
    FollowListType? type,
  }) {
    return FollowListLoaded(
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      type: type ?? this.type,
    );
  }
}
class FollowListError extends FollowListState {
  final String message;
  FollowListError(this.message);
}

enum FollowListType { followers, following }
