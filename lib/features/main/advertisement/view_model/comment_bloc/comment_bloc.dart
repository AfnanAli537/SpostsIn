import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/enums/home_enums.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class AdCommentsBloc extends Bloc<AdCommentsEvent, AdCommentsState> {
  final AdsRepositoryImpl adsRepo;
  final prefs = getIt<SharedPref>();

  AdCommentsBloc({
    required this.adsRepo,
    required SharedPreferences sharedPreferences,
  }) : super(AdCommentsInitial()) {
    on<FetchAdComments>(_onFetchAdComments);
    on<AddAdComment>(_onAddAdComment);
    on<EditAdComment>(_onEditAdComment);
    on<DeleteAdComment>(_onDeleteAdComment);
  }

  String? get currentUserId => prefs.getUserId();

  Future<void> _onFetchAdComments(
    FetchAdComments event,
    Emitter<AdCommentsState> emit,
  ) async {
    try {
      if (event.isRefresh || state is! AdCommentsLoaded) {
        emit(AdCommentsLoading());
        final response = await adsRepo.getAdComments(
          adId: event.adId,
          pageNumber: 1,
        );
        emit(AdCommentsLoaded(
          comments: response.items,
          hasNextPage: response.hasNextPage,
          currentPage: 1,
          totalCount: response.totalCount,
        ));
      } else {
        final currentState = state as AdCommentsLoaded;
        if (!currentState.hasNextPage) return;

        emit(AdCommentsLoadingMore(currentState.comments));
        final nextPage = currentState.currentPage + 1;
        final response = await adsRepo.getAdComments(
          adId: event.adId,
          pageNumber: nextPage,
        );
        emit(AdCommentsLoaded(
          comments: [...currentState.comments, ...response.items],
          hasNextPage: response.hasNextPage,
          currentPage: nextPage,
          totalCount: response.totalCount,
        ));
      }
    } catch (e) {
      emit(AdCommentsError(
        'Failed to load comments: ${e is ApiException ? e.message : e.toString()}',
      ));
    }
  }

  Future<void> _onAddAdComment(
    AddAdComment event,
    Emitter<AdCommentsState> emit,
  ) async {
    try {
      await adsRepo.addAdComment(adId: event.adId, text: event.text);
      final response =
          await adsRepo.getAdComments(adId: event.adId, pageNumber: 1);
      emit(AdCommentsLoaded(
        comments: response.items,
        hasNextPage: response.hasNextPage,
        currentPage: 1,
        totalCount: response.totalCount,
        action: CommentAction.added,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AdCommentsLoaded(
        comments: response.items,
        hasNextPage: response.hasNextPage,
        currentPage: 1,
        totalCount: response.totalCount,
        action: CommentAction.none,
      ));
    } catch (e) {
      emit(AdCommentsError('Failed to add comment: ${e.toString()}'));
    }
  }

  Future<void> _onEditAdComment(
    EditAdComment event,
    Emitter<AdCommentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdCommentsLoaded) return;

    try {
      await adsRepo.editAdComment(
          commentId: event.commentId, text: event.text);
      final updatedComments = currentState.comments.map((c) {
        if (c.commentId == event.commentId) return c.copyWith(text: event.text);
        return c;
      }).toList();

      emit(AdCommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount,
        action: CommentAction.edited,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AdCommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount,
        action: CommentAction.none,
      ));
    } catch (e) {
      emit(AdCommentsError('Failed to edit comment: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAdComment(
    DeleteAdComment event,
    Emitter<AdCommentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdCommentsLoaded) return;

    try {
      await adsRepo.deleteAdComment(
          adId: event.adId, commentId: event.commentId);
      final updatedComments = currentState.comments
          .where((c) => c.commentId != event.commentId)
          .toList();

      emit(AdCommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount - 1,
        action: CommentAction.deleted,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AdCommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount - 1,
        action: CommentAction.none,
      ));
    } catch (e) {
      emit(AdCommentsError('Failed to delete comment: ${e.toString()}'));
    }
  }
}