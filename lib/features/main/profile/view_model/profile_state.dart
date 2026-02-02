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

class ProfileActionSuccess extends ProfileState {
  final String message;
  ProfileActionSuccess(this.message);
}

class ProfileActionError extends ProfileState {
  final String message;
  ProfileActionError(this.message);
}