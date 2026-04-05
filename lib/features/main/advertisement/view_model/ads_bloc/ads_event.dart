part of 'ads_bloc.dart';

sealed class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdsFeed extends AdsEvent {
  final int page;
  const FetchAdsFeed({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadMoreAds extends AdsEvent {}

class LikeAd extends AdsEvent {
  final String adId;
  const LikeAd(this.adId);

  @override
  List<Object?> get props => [adId];
}

class LogAdClick extends AdsEvent {
  final String adId;
  const LogAdClick(this.adId);

  @override
  List<Object?> get props => [adId];
}

class CreateAd extends AdsEvent {
  final String title;
  final String description;
  final String? mediaFilePath;
  final double price;
  final String? actionUrl;
  final String? actionText;
  final DateTime startDate;
  final DateTime endDate;
  final int sportTypeId;
  final double videoDuration;
  final List<int> targetAudiences;

  const CreateAd({
    required this.title,
    required this.description,
    this.mediaFilePath,
    required this.price,
    this.actionUrl,
    this.actionText,
    required this.startDate,
    required this.endDate,
    required this.sportTypeId,
    this.videoDuration = 0,
    this.targetAudiences = const [],
  });

  @override
  List<Object?> get props => [title, description, price, startDate, endDate];
}

class UpdateAd extends AdsEvent {
  final String adId;
  final String title;
  final String description;
  final String? mediaFilePath;
  final double price;
  final String? actionUrl;
  final String? actionText;
  final DateTime startDate;
  final DateTime endDate;
  final int? sportTypeId;
  final double videoDuration;
  final List<int> targetAudiences;

  const UpdateAd({
    required this.adId,
    required this.title,
    required this.description,
    this.mediaFilePath,
    required this.price,
    this.actionUrl,
    this.actionText,
    required this.startDate,
    required this.endDate,
    this.sportTypeId,
    this.videoDuration = 0,
    this.targetAudiences = const [],
  });

  @override
  List<Object?> get props => [adId];
}

class DeleteAd extends AdsEvent {
  final String adId;
  const DeleteAd({required this.adId});

  @override
  List<Object?> get props => [adId];
}

class ToggleAdStatus extends AdsEvent {
  final String adId;
  const ToggleAdStatus({required this.adId});

  @override
  List<Object?> get props => [adId];
}

class FetchUserAds extends AdsEvent {
  final String? userId;
  final bool? isActive;
  final int page;
  final int size;

  const FetchUserAds({
    this.userId,
    this.isActive,
    this.page = 1,
    this.size = 10,
  });

  @override
  List<Object?> get props => [userId, isActive, page, size];
}

class SendAdProgress extends AdsEvent {
  final String adId;
  final double watchedTime;
  final bool isWatched;
  final double zoomScale;

  const SendAdProgress({
    required this.adId,
    required this.watchedTime,
    required this.isWatched,
    this.zoomScale = 1.0,
  });

  @override
  List<Object?> get props => [adId, watchedTime, isWatched];
}