import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';

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
  final ProfileModel currentProfile;
  final File? newImage;
  final String? oldImage;
  final String? firstName;
  final String? lastName;
  final String? clubName;
  final String? instituteName;
  final String? bio;
  final List<String>? sports;
  final double? height;
  final double? weight;
  final String? position;
  final int? age;
  final int? yearsOfExperience;
  final String? specialization;
  final String? foundationDate;
  final String? industry;
  final String? gender;
  final String? location;
  final bool? hasClub;

  const UpdateProfile({
    required this.currentProfile,  // 👈 required
    this.newImage,
    this.oldImage,
    this.firstName,
    this.lastName,
    this.clubName,
    this.instituteName,
    this.bio,
    this.sports,
    this.height,
    this.weight,
    this.position,
    this.age,
    this.yearsOfExperience,
    this.specialization,
    this.foundationDate,
    this.industry,
    this.gender,
    this.location,
    this.hasClub,
  });

  @override
  List<Object?> get props => [
        currentProfile,
        newImage,
        oldImage,
        firstName,
        lastName,
        clubName,
        instituteName,
        bio,
        sports,
        height,
        weight,
        position,
        age,
        yearsOfExperience,
        specialization,
        foundationDate,
        industry,
        gender,
        location,
        hasClub,
      ];
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
// New events for accept/reject
class AcceptConnectionRequestOnItem extends ProfileEvent {
  final String senderId;
  const AcceptConnectionRequestOnItem(this.senderId);
}
class RejectConnectionRequestOnItem extends ProfileEvent {
  final String senderId;
  const RejectConnectionRequestOnItem(this.senderId);
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
  final int page;
  final int pageSize;

  const LoadInterests({
    this.page = 1,
    this.pageSize = 5,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
class LoadMoreInterests extends ProfileEvent {
  final String userId;
  const LoadMoreInterests({required this.userId});
}

class ProfileLoadingMoreInterests extends ProfileEvent {
  const ProfileLoadingMoreInterests();
}