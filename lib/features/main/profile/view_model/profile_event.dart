abstract class ProfileEvent {}

class LoadMyProfile extends ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;
  
  LoadUserProfile(this.userId);
}

class FollowUser extends ProfileEvent {
  final String userId;
  
  FollowUser(this.userId);
}

class UnfollowUser extends ProfileEvent {
  final String userId;
  
  UnfollowUser(this.userId);
}

class ConnectWithUser extends ProfileEvent {
  final String userId;
  
  ConnectWithUser(this.userId);
}

class DisconnectFromUser extends ProfileEvent {
  final String userId;
  
  DisconnectFromUser(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> updateData;
  
  UpdateProfile(this.updateData);
}