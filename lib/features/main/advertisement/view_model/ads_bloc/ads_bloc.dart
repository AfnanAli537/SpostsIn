import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';

part 'ads_event.dart';
part 'ads_state.dart';

@injectable
class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsRepositoryImpl adsRepo;

  AdsBloc({required this.adsRepo}) : super(AdsInitial()) {
    on<FetchAdsFeed>(_onFetchAdsFeed);
    on<LoadMoreAds>(_onLoadMoreAds);
    on<LikeAd>(_onLikeAd);
    on<LogAdClick>(_onLogAdClick);
    on<CreateAd>(_onCreateAd);
    on<UpdateAd>(_onUpdateAd);
    on<DeleteAd>(_onDeleteAd);
    on<ToggleAdStatus>(_onToggleAdStatus);
    on<FetchUserAds>(_onFetchUserAds);
    on<SendAdProgress>(_onSendAdProgress);
  }

  final List<AdModel> _ads = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;
  final int _pageSize = 10;

  // ─── Feed ──────────────────────────────────────────────────────────────────

  Future<void> _onFetchAdsFeed(
    FetchAdsFeed event,
    Emitter<AdsState> emit,
  ) async {
    try {
      emit(AdsLoading());
      _ads.clear();
      _currentPage = 1;
      _hasNextPage = true;

      final result = await adsRepo.getAdsFeed(page: 1, size: _pageSize);
      _ads.addAll(result.items);
      _hasNextPage = result.hasNextPage;

      emit(AdsLoaded(ads: List.from(_ads), hasNextPage: _hasNextPage));
    } catch (e) {
      emit(AdsError(
        'Failed to fetch ads: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMoreAds(
    LoadMoreAds event,
    Emitter<AdsState> emit,
  ) async {
    if (_isFetching || !_hasNextPage) return;
    final currentState = state;
    if (currentState is! AdsLoaded) return;

    _isFetching = true;
    try {
      emit(AdsLoadingMore(currentState.ads));

      final nextPage = _currentPage + 1;
      final result = await adsRepo.getAdsFeed(page: nextPage, size: _pageSize);

      _ads.addAll(result.items);
      _currentPage = nextPage;
      _hasNextPage = result.hasNextPage;

      emit(AdsLoaded(ads: List.from(_ads), hasNextPage: _hasNextPage));
    } catch (e) {
      emit(AdsError(
        'Failed to load more ads: ${e is ApiException ? e.message : e.toString()}',
      ));
    } finally {
      _isFetching = false;
    }
  }

  // ─── Like (optimistic) ─────────────────────────────────────────────────────

  Future<void> _onLikeAd(LikeAd event, Emitter<AdsState> emit) async {
    final currentState = state;
    if (currentState is! AdsLoaded) return;

    final updatedAds = currentState.ads.map((ad) {
      if (ad.id == event.adId) {
        final newLiked = !ad.isLikedByCurrentUser;
        return ad.copyWith(
          isLikedByCurrentUser: newLiked,
          likesCount: newLiked ? ad.likesCount + 1 : ad.likesCount - 1,
        );
      }
      return ad;
    }).toList();

    emit(AdsLoaded(ads: updatedAds, hasNextPage: currentState.hasNextPage));

    try {
      await adsRepo.likeAd(adId: event.adId);
    } catch (e) {
      log('Like ad failed: $e');
      // revert
      final revertedAds = updatedAds.map((ad) {
        if (ad.id == event.adId) {
          final originalLiked = !ad.isLikedByCurrentUser;
          return ad.copyWith(
            isLikedByCurrentUser: originalLiked,
            likesCount:
                originalLiked ? ad.likesCount + 1 : ad.likesCount - 1,
          );
        }
        return ad;
      }).toList();
      emit(AdsLoaded(ads: revertedAds, hasNextPage: currentState.hasNextPage));
    }
  }

  // ─── Click log (fire-and-forget) ───────────────────────────────────────────

  Future<void> _onLogAdClick(
    LogAdClick event,
    Emitter<AdsState> emit,
  ) async {
    await adsRepo.logAdClick(adId: event.adId);
  }

  // ─── Create ────────────────────────────────────────────────────────────────

  Future<void> _onCreateAd(CreateAd event, Emitter<AdsState> emit) async {
    final currentState = state;
    final previousAds =
        currentState is AdsLoaded ? List<AdModel>.from(currentState.ads) : <AdModel>[];
    final previousHasNextPage =
        currentState is AdsLoaded ? currentState.hasNextPage : false;

    emit(AdsLoaded(
      ads: previousAds,
      hasNextPage: previousHasNextPage,
      isUploading: true,
    ));

    try {
      final response = await adsRepo.createAd(
        title: event.title,
        description: event.description,
        mediaFilePath: event.mediaFilePath,
        price: event.price,
        actionUrl: event.actionUrl,
        actionText: event.actionText,
        startDate: event.startDate,
        endDate: event.endDate,
        sportTypeId: event.sportTypeId,
        videoDuration: event.videoDuration,
        targetAudiences: event.targetAudiences,
      );

      emit(AdsLoaded(
        ads: previousAds,
        hasNextPage: previousHasNextPage,
        isUploading: false,
      ));

      // The backend returns isSuccess + message. We infer payment/active status
      // from the message — a 'Subscription' response means paid & active.
      final message = (response['message'] as String?) ?? '';
      final isPaid = message.toLowerCase().contains('subscription') ||
          message.toLowerCase().contains('paid') ||
          message.toLowerCase().contains('active');

      emit(AdCreated(isPaid: isPaid, isActive: isPaid, adId: ''));

      await Future.delayed(const Duration(milliseconds: 100));
      emit(AdsLoaded(ads: previousAds, hasNextPage: previousHasNextPage));
    } catch (e) {
      emit(AdsLoaded(
        ads: previousAds,
        hasNextPage: previousHasNextPage,
        isUploading: false,
      ));
      emit(AdsError(
        'Failed to create ad: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  // ─── Update ────────────────────────────────────────────────────────────────

  Future<void> _onUpdateAd(UpdateAd event, Emitter<AdsState> emit) async {
    try {
      await adsRepo.updateAd(
        adId: event.adId,
        title: event.title,
        description: event.description,
        mediaFilePath: event.mediaFilePath,
        price: event.price,
        actionUrl: event.actionUrl,
        actionText: event.actionText,
        startDate: event.startDate,
        endDate: event.endDate,
        sportTypeId: event.sportTypeId,
        videoDuration: event.videoDuration,
        targetAudiences: event.targetAudiences,
      );
      emit(AdUpdated());
      await Future.delayed(const Duration(milliseconds: 100));
      final currentState = state;
      if (currentState is AdsLoaded) {
        emit(AdsLoaded(
          ads: currentState.ads,
          hasNextPage: currentState.hasNextPage,
        ));
      }
    } catch (e) {
      emit(AdsError(
        'Failed to update ad: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  Future<void> _onDeleteAd(DeleteAd event, Emitter<AdsState> emit) async {
    final currentState = state;
    try {
      await adsRepo.deleteAd(adId: event.adId);

      if (currentState is AdsLoaded) {
        final updated =
            currentState.ads.where((a) => a.id != event.adId).toList();
        _ads.removeWhere((a) => a.id == event.adId);
        emit(AdsLoaded(ads: updated, hasNextPage: currentState.hasNextPage));
      } else if (currentState is UserAdsLoaded) {
        final updated =
            currentState.ads.where((a) => a.id != event.adId).toList();
        emit(UserAdsLoaded(ads: updated, hasNextPage: currentState.hasNextPage));
      }

      emit(AdDeleted());
    } catch (e) {
      emit(AdsError(
        'Failed to delete ad: ${e is ApiException ? e.message : e.toString()}',
      ));
      if (currentState is AdsLoaded) {
        emit(AdsLoaded(
          ads: currentState.ads,
          hasNextPage: currentState.hasNextPage,
        ));
      }
    }
  }

  // ─── Toggle status ─────────────────────────────────────────────────────────

  Future<void> _onToggleAdStatus(
    ToggleAdStatus event,
    Emitter<AdsState> emit,
  ) async {
    try {
      await adsRepo.toggleAdStatus(adId: event.adId);
      emit(AdStatusToggled());
      await Future.delayed(const Duration(milliseconds: 100));
      // Refresh user ads list after toggle
      add(const FetchUserAds());
    } catch (e) {
      emit(AdsError(
        'Failed to toggle ad: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  // ─── User ads ──────────────────────────────────────────────────────────────

  Future<void> _onFetchUserAds(
    FetchUserAds event,
    Emitter<AdsState> emit,
  ) async {
    try {
      if (event.page == 1) emit(AdsLoading());

      final result = await adsRepo.getUserAds(
        userId: event.userId,
        isActive: event.isActive,
        page: event.page,
        size: event.size,
      );

      emit(UserAdsLoaded(
        ads: result.items,
        hasNextPage: result.hasNextPage,
      ));
    } catch (e) {
      emit(AdsError(
        'Failed to fetch user ads: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  // ─── Progress ──────────────────────────────────────────────────────────────

  Future<void> _onSendAdProgress(
    SendAdProgress event,
    Emitter<AdsState> emit,
  ) async {
    await adsRepo.sendAdProgress(
      adId: event.adId,
      watchedTime: event.watchedTime,
      isWatched: event.isWatched,
      zoomScale: event.zoomScale,
    );
  }
}