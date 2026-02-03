// comments_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';

part 'comment_event.dart';
part 'comment_state.dart';


class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostsRepositoryImpl commentsRepo;
   final prefs=getIt<SharedPref>();

  CommentsBloc({
    required this.commentsRepo,
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
      if (event.isRefresh || event.pageNumber == 1) {
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
        if (currentState is CommentsLoaded) {
          emit(CommentsLoadingMore(currentState.comments));

          final response = await commentsRepo.getComments(
            postId: event.postId,
            pageNumber: event.pageNumber,
          );

          final allComments = [...currentState.comments, ...response.items];

          emit(CommentsLoaded(
            comments: allComments,
            hasNextPage: response.hasNextPage,
            currentPage: event.pageNumber,
            totalCount: response.totalCount,
          ));
        }
      }
    } catch (e) {
      emit(CommentsError('Failed to load comments: ${e.toString()}'));
    }
  }

  // ✅ Add Comment
  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    final currentState = state;

    emit(CommentAdding());

    try {
      final newComment = await commentsRepo.addComment(
        postId: event.postId,
        text: event.text,
      );

      // Update comments list
      if (currentState is CommentsLoaded) {
        final updatedComments = [newComment, ...currentState.comments];
        emit(CommentsLoaded(
          comments: updatedComments,
          hasNextPage: currentState.hasNextPage,
          currentPage: currentState.currentPage,
          totalCount: currentState.totalCount + 1,
        ));
      } else {
        emit(CommentsLoaded(
          comments: [newComment],
          hasNextPage: false,
          currentPage: 1,
          totalCount: 1,
        ));
      }

      emit(CommentAdded(newComment));
    } catch (e) {
      if (currentState is CommentsLoaded) {
        emit(CommentsLoaded(
          comments: currentState.comments,
          hasNextPage: currentState.hasNextPage,
          currentPage: currentState.currentPage,
          totalCount: currentState.totalCount,
        ));
      }
      emit(CommentsError('Failed to add comment: ${e.toString()}'));
    }
  }

  // ✅ Edit Comment
  Future<void> _onEditComment(
    EditComment event,
    Emitter<CommentsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! CommentsLoaded) return;

    try {
      final editedComment = await commentsRepo.editComment(
        commentId: event.commentId,
        comment: event.text,
      );

      // Update the comment in the list
      final updatedComments = currentState.comments.map((comment) {
        return comment.commentId == event.commentId ? editedComment : comment;
      }).toList();

      emit(CommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount,
      ));
      
      emit(CommentEdited(editedComment));
    } catch (e) {
      emit(CommentsLoaded(
        comments: currentState.comments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount,
      ));
      emit(CommentsError('Failed to edit comment: ${e.toString()}'));
    }
  }

  // ✅ Delete Comment
  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! CommentsLoaded) return;

    try {
      await commentsRepo.deleteComment(
        postId: event.postId,
        commentId: event.commentId,
      );

      // Remove from list
      final updatedComments = currentState.comments
          .where((comment) => comment.commentId != event.commentId)
          .toList();

      emit(CommentsLoaded(
        comments: updatedComments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount - 1,
      ));
      
      emit(CommentDeleted(event.commentId));
    } catch (e) {
      emit(CommentsLoaded(
        comments: currentState.comments,
        hasNextPage: currentState.hasNextPage,
        currentPage: currentState.currentPage,
        totalCount: currentState.totalCount,
      ));
      emit(CommentsError('Failed to delete comment: ${e.toString()}'));
    }
  }
}