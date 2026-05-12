part of 'likes_bloc.dart';

sealed class LikesEvent extends Equatable {
  const LikesEvent();

  @override
  List<Object?> get props => [];
}

class FetchLikes extends LikesEvent {
  final String postId;
  final int page;
  final bool isRefresh;

  const FetchLikes({
    required this.postId,
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [postId, page, isRefresh];
}
