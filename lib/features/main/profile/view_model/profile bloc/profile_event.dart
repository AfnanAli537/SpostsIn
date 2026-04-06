import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyProfile extends ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;
  const LoadUserProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> updateData;
  const UpdateProfile({required this.updateData});

  @override
  List<Object?> get props => [updateData];
}

class ToggleFollow extends ProfileEvent {
  final String userId;
  const ToggleFollow({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// ── Connection Events ────────────────────────────────────────────────────────

/// Send a new connection request (connectionStatus is null → becomes "Pending")
class SendConnectionRequest extends ProfileEvent {
  final String receiverId;
  const SendConnectionRequest({required this.receiverId});

  @override
  List<Object?> get props => [receiverId];
}

/// Remove an accepted contact (connectionStatus is "Accepted" → becomes null)
class RemoveContact extends ProfileEvent {
  final String targetId;
  const RemoveContact({required this.targetId});

  @override
  List<Object?> get props => [targetId];
}

// ── Achievement Events ───────────────────────────────────────────────────────

class LoadAchievements extends ProfileEvent {
  final String userId;
  final int page;
  final int size;

  const LoadAchievements({required this.userId, this.page = 1, this.size = 10});

  @override
  List<Object?> get props => [userId, page, size];
}

class CreateAchievement extends ProfileEvent {
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime date;

  const CreateAchievement({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.date,
  });

  @override
  List<Object?> get props => [title, subtitle, imageUrl, date];
}

class UpdateAchievement extends ProfileEvent {
  final String achievementId;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime date;

  const UpdateAchievement({
    required this.achievementId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.date,
  });

  @override
  List<Object?> get props => [achievementId, title, subtitle, imageUrl, date];
}

class DeleteAchievement extends ProfileEvent {
  final String achievementId;
  const DeleteAchievement({required this.achievementId});

  @override
  List<Object?> get props => [achievementId];
}

// ── Posts Events ─────────────────────────────────────────────────────────────

class LoadPosts extends ProfileEvent {
  final String userId;
  final int page;
  final int size;

  const LoadPosts({required this.userId, this.page = 1, this.size = 10});

  @override
  List<Object?> get props => [userId, page, size];
}

// ── Opportunities Events ─────────────────────────────────────────────────────

class LoadOpportunities extends ProfileEvent {
  final String userId;
  final int page;
  final int pageSize;

  const LoadOpportunities({
    required this.userId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [userId, page, pageSize];
}

// ── Courses Events ───────────────────────────────────────────────────────────

class LoadCourses extends ProfileEvent {
  final String userId;
  final int page;
  final int pageSize;

  const LoadCourses({
    required this.userId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [userId, page, pageSize];
}

// ── Interests Events ─────────────────────────────────────────────────────────

class LoadInterests extends ProfileEvent {
  final String userId;
  final int page;
  final int pageSize;

  const LoadInterests({
    required this.userId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [userId, page, pageSize];
}