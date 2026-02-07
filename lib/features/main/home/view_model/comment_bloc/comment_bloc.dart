// comments_bloc.dart
// import 'dart:develper';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/src/shared_preferences_legacy.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/interface/home_tap_enums.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';

part 'comment_event.dart';
part 'comment_state.dart';


class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostsRepositoryImpl commentsRepo;
   final prefs=getIt<SharedPref>();

  CommentsBloc({
    required this.commentsRepo, required SharedPreferences prefs,
  }) : super(CommentsInitial()) {
    on<FetchComments>(_onFetchComments);
    on<AddComment>(_onAddComment);
    on<EditComment>(_onEditComment);
    on<DeleteComment>(_onDeleteComment);
  }
  // ✅ Get Current User ID
  String? get currentUserId => prefs.getUserId();

  // ✅ Fetch Comments (with Pagination)
  Future<void> _onFetchComments(
    FetchComments event,
    Emitter<CommentsState> emit,
  ) async {
    try {
      if (event.isRefresh ||state is! CommentsLoaded) {
        emit(CommentsLoading());

        final response = await commentsRepo.getComments(
          postId: event.postId,
          pageNumber: 1,
        );

        emit(CommentsLoaded(
          comments: response.items,
          hasNextPage: response.hasNextPage,
          currentPage: 1,
          totalCount: response.totalCount,
        ));
      } else {
        // Load more
        final currentState = state;
          // Increment page by 1 from the current state
        if (currentState is CommentsLoaded) {
    if (!currentState.hasNextPage) return;
          emit(CommentsLoadingMore(currentState.comments));
 final nextPage = currentState.currentPage + 1;

          final response = await commentsRepo.getComments(
            postId: event.postId,
            pageNumber: nextPage,
          );

          final allComments = [...currentState.comments, ...response.items];

          emit(CommentsLoaded(
            comments: allComments,
            hasNextPage: response.hasNextPage,
            currentPage: nextPage,
            totalCount: response.totalCount,
          ));
        }
      }
    } catch (e) {
      emit(CommentsError('Failed to load comments: ${e.toString()}'));
    }
  }

  // ✅ Add Comment - FIXED
Future<void> _onAddComment(
  AddComment event,
  Emitter<CommentsState> emit,
) async {
  // final currentState = state;

  try {
    // استدعاء الAPI أولاً
    await commentsRepo.addComment(
      postId: event.postId,
      text: event.text,
    );

    // بعد النجاح، نعمل refresh للكومنتات عشان نجيب البيانات الصحيحة من السيرفر
    final response = await commentsRepo.getComments(
      postId: event.postId,
      pageNumber: 1,
    );

    emit(CommentsLoaded(
      comments: response.items,
      hasNextPage: response.hasNextPage,
      currentPage: 1,
      totalCount: response.totalCount,
      action: CommentAction.added,
    ));

    // Reset action
    await Future.delayed(const Duration(milliseconds: 100));
    emit(CommentsLoaded(
      comments: response.items,
      hasNextPage: response.hasNextPage,
      currentPage: 1,
      totalCount: response.totalCount,
      action: CommentAction.none,
    ));

  } catch (e) {
    emit(CommentsError('Failed to add comment: ${e.toString()}'));
  }
}

// ✅ Edit Comment - FIXED
Future<void> _onEditComment(
  EditComment event,
  Emitter<CommentsState> emit,
) async {
  final currentState = state;

  if (currentState is! CommentsLoaded) return;

  try {
    // استدعاء الAPI
    await commentsRepo.editComment(
      commentId: event.commentId,
      text: event.text,
    );

    // تحديث الكومنت في القائمة مباشرة
    final List<CommentModel> updatedComments = currentState.comments.map((comment) {
      if (comment.commentId == event.commentId) {
        return comment.copyWith(text: event.text); // تأكد إن عندك copyWith في CommentModel
      }
      return comment;
    }).toList();

    emit(CommentsLoaded(
      comments: updatedComments,
      hasNextPage: currentState.hasNextPage,
      currentPage: currentState.currentPage,
      totalCount: currentState.totalCount,
      action: CommentAction.edited,
    ));

    // Reset action
    await Future.delayed(const Duration(milliseconds: 100));
    emit(CommentsLoaded(
      comments: updatedComments,
      hasNextPage: currentState.hasNextPage,
      currentPage: currentState.currentPage,
      totalCount: currentState.totalCount,
      action: CommentAction.none,
    ));

  } catch (e) {
    emit(CommentsError('Failed to edit comment: ${e.toString()}'));
  }
}

// ✅ Delete Comment - FIXED
Future<void> _onDeleteComment(
  DeleteComment event,
  Emitter<CommentsState> emit,
) async {
  final currentState = state;

  if (currentState is! CommentsLoaded) return;

  try {
    // استدعاء الAPI
    await commentsRepo.deleteComment(
      postId: event.postId,
      commentId: event.commentId,
    );

    // حذف الكومنت من القائمة مباشرة
    final updatedComments = currentState.comments
        .where((comment) => comment.commentId != event.commentId)
        .toList();

    emit(CommentsLoaded(
      comments: updatedComments,
      hasNextPage: currentState.hasNextPage,
      currentPage: currentState.currentPage,
      totalCount: currentState.totalCount - 1,
      action: CommentAction.deleted,
    ));

    // Reset action
    await Future.delayed(const Duration(milliseconds: 100));
    emit(CommentsLoaded(
      comments: updatedComments,
      hasNextPage: currentState.hasNextPage,
      currentPage: currentState.currentPage,
      totalCount: currentState.totalCount - 1,
      action: CommentAction.none,
    ));

  } catch (e) {
    emit(CommentsError('Failed to delete comment: ${e.toString()}'));
  }
}

}






