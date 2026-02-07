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
  final CommentAction action;

  const CommentsLoaded({
    required this.comments,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
    this.action = CommentAction.none,
  });

  CommentsLoaded copyWith({
    List<CommentModel>? comments,
    bool? hasNextPage,
    int? currentPage,
    int? totalCount,
    CommentAction? action,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      action: action ?? CommentAction.none,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    hasNextPage,
    currentPage,
    totalCount,
    action,
  ];
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
