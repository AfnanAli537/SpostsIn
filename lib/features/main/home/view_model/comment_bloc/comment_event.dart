part of 'comment_bloc.dart';





sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class FetchComments extends CommentsEvent {
  final String postId;
  final int pageNumber;
  final bool isRefresh;

  const FetchComments({
    required this.postId,
    this.pageNumber = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [postId, pageNumber, isRefresh];
}

class AddComment extends CommentsEvent {
  final String postId;
  final String text;

  const AddComment({required this.postId, required this.text});

  @override
  List<Object?> get props => [postId, text];
}

class EditComment extends CommentsEvent {
  final String commentId;
  final String text;

  const EditComment({required this.commentId, required this.text});

  @override
  List<Object?> get props => [commentId, text];
}

class DeleteComment extends CommentsEvent {
  final String postId;
  final String commentId;

  const DeleteComment({required this.postId, required this.commentId});

  @override
  List<Object?> get props => [postId, commentId];
}