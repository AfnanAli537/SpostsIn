import '../model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final bool isOwnProfile;

  ProfileLoaded({
    required this.profile,
    this.isOwnProfile = false,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileActionLoading extends ProfileState {
  final ProfileModel profile;
  final String action;

  ProfileActionLoading({
    required this.profile,
    required this.action,
  });
}

class ProfileActionSuccess extends ProfileState {
  final ProfileModel profile;
  final String message;

  ProfileActionSuccess({
    required this.profile,
    required this.message,
  });
}

class ProfileActionError extends ProfileState {
  final ProfileModel profile;
  final String message;

  ProfileActionError({
    required this.profile,
    required this.message,
  });
}