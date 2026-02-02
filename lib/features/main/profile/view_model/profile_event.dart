abstract class ProfileEvent {}

class LoadMyProfile extends ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class ToggleFollowUser extends ProfileEvent {
  final String userId;
  ToggleFollowUser(this.userId);
}

class ToggleConnectUser extends ProfileEvent {
  final String userId;
  ToggleConnectUser(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> updateData;
  UpdateProfile(this.updateData);
}