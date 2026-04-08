part of 'follow_bloc.dart';


abstract class FollowingEvent {}
class LoadFollowing extends FollowingEvent {
  final String userId;
  LoadFollowing(this.userId);
}
class LoadMoreFollowing extends FollowingEvent {}