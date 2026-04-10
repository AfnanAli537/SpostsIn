part of 'follow_bloc.dart';

abstract class FollowListEvent {}
class LoadFollowList extends FollowListEvent {
  final String userId;
  final FollowListType type;
  LoadFollowList(this.userId, this.type);
}
class LoadMoreFollowList extends FollowListEvent {}
class ToggleFollowOnItem extends FollowListEvent {
  final String targetUserId;
  ToggleFollowOnItem(this.targetUserId);
}
class SendConnectionRequestOnItem extends FollowListEvent {
  final String receiverId;
  SendConnectionRequestOnItem(this.receiverId);
}
class RemoveContactOnItem extends FollowListEvent {
  final String targetId;
  RemoveContactOnItem(this.targetId);
}
// New events for accept/reject
class AcceptConnectionRequestOnItem extends FollowListEvent {
  final String senderId;
  AcceptConnectionRequestOnItem(this.senderId);
}
class RejectConnectionRequestOnItem extends FollowListEvent {
  final String senderId;
  RejectConnectionRequestOnItem(this.senderId);
}
