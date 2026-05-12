part of 'likes_bloc.dart';

sealed class AdLikesEvent extends Equatable {
  const AdLikesEvent();
  @override
  List<Object?> get props => [];
}

class FetchAdLikes extends AdLikesEvent {
  final String adId;
  final int page;
  final bool isRefresh;

  const FetchAdLikes({
    required this.adId,
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [adId, page, isRefresh];
}