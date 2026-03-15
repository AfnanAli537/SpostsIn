part of 'ads_bloc.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsLoaded extends AdsState {
  final List<AdModel> ads;
  final bool hasNextPage;
  final bool isUploading;

  const AdsLoaded({
    required this.ads,
    required this.hasNextPage,
    this.isUploading = false,
  });

  @override
  List<Object?> get props => [ads, hasNextPage, isUploading];
}

class AdsLoadingMore extends AdsState {
  final List<AdModel> currentAds;
  const AdsLoadingMore(this.currentAds);

  @override
  List<Object?> get props => [currentAds];
}

class UserAdsLoaded extends AdsState {
  final List<AdModel> ads;
  final bool hasNextPage;

  const UserAdsLoaded({required this.ads, required this.hasNextPage});

  @override
  List<Object?> get props => [ads, hasNextPage];
}

class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitted right after the API responds to CreateAd.
/// [isPaid] true  → show success screen
/// [isPaid] false → show payment screen (ad saved as draft)
class AdCreated extends AdsState {
  final bool isPaid;
  final bool isActive;
  final String adId;

  const AdCreated({
    required this.isPaid,
    required this.isActive,
    required this.adId,
  });

  @override
  List<Object?> get props => [isPaid, isActive, adId];
}

class AdUpdated extends AdsState {}

class AdDeleted extends AdsState {}

class AdStatusToggled extends AdsState {}