part of 'comment_bloc.dart';

sealed class AdCommentsEvent extends Equatable {
  const AdCommentsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAdComments extends AdCommentsEvent {
  final String adId;
  final int pageNumber;
  final bool isRefresh;

  const FetchAdComments({
    required this.adId,
    this.pageNumber = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [adId, pageNumber, isRefresh];
}

class AddAdComment extends AdCommentsEvent {
  final String adId;
  final String text;
  AddAdComment({required this.adId, required this.text});

  @override
  List<Object?> get props => [adId, text];
}

class EditAdComment extends AdCommentsEvent {
  final String commentId;
  final String text;
  EditAdComment({required this.commentId, required this.text});

  @override
  List<Object?> get props => [commentId, text];
}

class DeleteAdComment extends AdCommentsEvent {
  final String adId;
  final String commentId;
  const DeleteAdComment({required this.adId, required this.commentId});

  @override
  List<Object?> get props => [adId, commentId];
}