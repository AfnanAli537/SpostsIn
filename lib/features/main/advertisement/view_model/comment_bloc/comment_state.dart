part of 'comment_bloc.dart';

sealed class AdCommentsState extends Equatable {
  const AdCommentsState();
  @override
  List<Object?> get props => [];
}

class AdCommentsInitial extends AdCommentsState {}

class AdCommentsLoading extends AdCommentsState {}

class AdCommentsLoaded extends AdCommentsState {
  final List<CommentModel> comments;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;
  final CommentAction action;

  const AdCommentsLoaded({
    required this.comments,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
    this.action = CommentAction.none,
  });

  AdCommentsLoaded copyWith({
    List<CommentModel>? comments,
    bool? hasNextPage,
    int? currentPage,
    int? totalCount,
    CommentAction? action,
  }) {
    return AdCommentsLoaded(
      comments: comments ?? this.comments,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      action: action ?? CommentAction.none,
    );
  }

  @override
  List<Object?> get props => [comments, hasNextPage, currentPage, totalCount, action];
}

class AdCommentsLoadingMore extends AdCommentsState {
  final List<CommentModel> currentComments;
  const AdCommentsLoadingMore(this.currentComments);

  @override
  List<Object?> get props => [currentComments];
}

class AdCommentsError extends AdCommentsState {
  final String message;
  const AdCommentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdCommentAdding extends AdCommentsState {}