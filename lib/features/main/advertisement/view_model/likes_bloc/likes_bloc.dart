import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/home/data/model/user_model.dart';

part 'likes_event.dart';
part 'likes_state.dart';

class AdLikesBloc extends Bloc<AdLikesEvent, AdLikesState> {
  final AdsRepositoryImpl adsRepo;

  AdLikesBloc({required this.adsRepo}) : super(AdLikesInitial()) {
    on<FetchAdLikes>(_onFetchAdLikes);
  }

  Future<void> _onFetchAdLikes(
    FetchAdLikes event,
    Emitter<AdLikesState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 1) {
        emit(AdLikesLoading());
        final result = await adsRepo.getAdLikes(
          adId: event.adId,
          pageNumber: 1,
        );
        final likes = result['likes'] as List<UserLists>;
        final hasNextPage = result['hasNextPage'] as bool;
        emit(AdLikesLoaded(likes: likes, hasMore: hasNextPage, currentPage: 1));
      } else {
        final currentState = state;
        if (currentState is AdLikesLoaded) {
          emit(AdLikesLoadingMore(currentState.likes));
          final result = await adsRepo.getAdLikes(
            adId: event.adId,
            pageNumber: event.page,
          );
          final newLikes = result['likes'] as List<UserLists>;
          final hasNextPage = result['hasNextPage'] as bool;
          emit(AdLikesLoaded(
            likes: [...currentState.likes, ...newLikes],
            hasMore: hasNextPage,
            currentPage: event.page,
          ));
        }
      }
    } catch (e) {
      emit(AdLikesError(
        'Failed to fetch likes: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }
}