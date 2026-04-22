import 'package:equatable/equatable.dart';
import '../../model/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final bool isOwnProfile;

  const ProfileLoaded({
    required this.profile,
    this.isOwnProfile = false,
  });

  @override
  List<Object?> get props => [profile, isOwnProfile];
}

class ProfileUpdated extends ProfileState {
  final ProfileModel profile;

  const ProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Action feedback states
class ProfileActionSuccess extends ProfileState {
  final String message;

  const ProfileActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileActionError extends ProfileState {
  final String message;

  const ProfileActionError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Achievement States
class AchievementsLoaded extends ProfileState {
  final List<Achievement> achievements;
  final bool hasMore;

  const AchievementsLoaded({
    required this.achievements,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [achievements, hasMore];
}

class AchievementCreated extends ProfileState {
  final Achievement achievement;

  const AchievementCreated({required this.achievement});

  @override
  List<Object?> get props => [achievement];
}

class AchievementUpdated extends ProfileState {
  final Achievement achievement;

  const AchievementUpdated({required this.achievement});

  @override
  List<Object?> get props => [achievement];
}

class AchievementDeleted extends ProfileState {
  final String achievementId;

  const AchievementDeleted({required this.achievementId});

  @override
  List<Object?> get props => [achievementId];
}

// Follow/Connect States
class FollowToggled extends ProfileState {
  final String userId;
  final bool isFollowing;

  const FollowToggled({
    required this.userId,
    required this.isFollowing,
  });

  @override
  List<Object?> get props => [userId, isFollowing];
}

class ConnectToggled extends ProfileState {
  final String userId;
  final bool isConnected;

  const ConnectToggled({
    required this.userId,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [userId, isConnected];
}

// Posts States
class PostsLoaded extends ProfileState {
  final List<Post> posts;
  final bool hasMore;

  const PostsLoaded({
    required this.posts,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [posts, hasMore];
}

// Opportunities States
class OpportunitiesLoaded extends ProfileState {
  final List<Opportunity> opportunities;
  final bool hasMore;

  const OpportunitiesLoaded({
    required this.opportunities,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [opportunities, hasMore];
}

// Courses States
class CoursesLoaded extends ProfileState {
  final List<Course> courses;
  final bool hasMore;

  const CoursesLoaded({
    required this.courses,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [courses, hasMore];
}

// Interests States
class InterestsLoaded extends ProfileState {
  final List<Interest> interests;
  final bool hasMore;

  const InterestsLoaded({
    required this.interests,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [interests, hasMore];
}