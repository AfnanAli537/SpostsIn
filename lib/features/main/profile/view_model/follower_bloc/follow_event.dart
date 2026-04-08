part of 'follow_bloc.dart';


abstract class FollowersEvent {}
class LoadFollowers extends FollowersEvent {
  final String userId;
  LoadFollowers(this.userId);
}
class LoadMoreFollowers extends FollowersEvent {}
