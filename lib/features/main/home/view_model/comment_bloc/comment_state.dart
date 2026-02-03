part of 'comment_bloc.dart';


sealed class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentModel> comments;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;

  const CommentsLoaded({
    required this.comments,
    this.hasNextPage = false,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [comments, hasNextPage, currentPage, totalCount];
}

class CommentsLoadingMore extends CommentsState {
  final List<CommentModel> currentComments;

  const CommentsLoadingMore(this.currentComments);

  @override
  List<Object?> get props => [currentComments];
}

class CommentsError extends CommentsState {
  final String message;

  const CommentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentAdding extends CommentsState {}

class CommentAdded extends CommentsState {
  final CommentModel comment;

  const CommentAdded(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentDeleted extends CommentsState {
  final String commentId;

  const CommentDeleted(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

class CommentEdited extends CommentsState {
  final CommentModel comment;

  const CommentEdited(this.comment);

  @override
  List<Object?> get props => [comment];
}